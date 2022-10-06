import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
// import 'package:motion_sensors/motion_sensors.dart';
import 'package:rive/rive.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
// import 'package:rive/src/rive_core/bones/bone.dart';
import 'package:rive/src/rive_core/shapes/rectangle.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

void main() {
  print('start main');
  runApp(GameWidget(
    game: MyGame(),
  ));
  if (!kIsWeb && Platform.isAndroid) {
    try {
      FlutterDisplayMode.setHighRefreshRate();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      print(e);
    }
  }
}

class MyGame extends FlameGame with HasTappables, HasDraggables {
  Shape? target;
  Vector2? court;
  Node? outerTail;
  Shape? ball;
  static double frameRate = 60;
  double y = 0;
  double x = 0;
  Vector2 ballVelocity = Vector2(0, 0);
  @override
  Color backgroundColor() => const Color(0xff471717);
  bool ballIsFalling = true; //

  @override
  Future<void> onLoad() async {
    // BubbleComponent.screenSize = size;
    print('Load Rive artboard...');
    loadRive(0, 0);
    await super.onLoad();
  }

  Future<void> loadRive(double xPosition, double yPosition) async {
    Artboard artboard = await loadArtboard(RiveFile.asset('assets/beach.riv'));
    CustomRiveComponent component = CustomRiveComponent(artboard: artboard);
    var diff = Vector2(artboard.width - size.x, artboard.height - size.y);

    component.position = -diff / 2;
    add(component);
    artboard.forEachComponent((child) {
      switch (child.name) {
        case 'target':
          target = child as Shape;
          print(child.name);
          break;

        case 'rectangle':
          court =
              Vector2((child as Rectangle).width, (child as Rectangle).height);
          // var scale = size.x / court.;
          print(court!.toString());
          break;
        case 'tail':
          outerTail = child as Node;
          print(child.name);
          break;
        case 'Ball':
          ball = child as Shape;
          print(child.name);
          break;
      }
    });
  }

  @override
  void onDragStart(int i, DragStartInfo info) {
    super.onDragStart(i, info);
    // print('handled 2?' + info.toString());
    // if (info.handled) {
    //   return;
    // }
    // ball.x = info.eventPosition.global.x;
    // ball.y = info.eventPosition.global.y;

    // createBubble(info.eventPosition.game.x, info.eventPosition.game.y);
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    super.onDragUpdate(i, info);

    target?.x += info.delta.game.x; // != 0 || info.delta.game.y != 0) {
    target?.y += info.delta.game.y;
    //info.handled = true;
  }

  @override
  void update(double dt) {
    if (outerTail != null) {
      Vector2 ballPos = Vector2(
          ball!.worldTranslation.values[0], ball!.worldTranslation.values[1]);
      Vector2 tailPos = Vector2(outerTail!.worldTranslation.values[0],
          outerTail!.worldTranslation.values[1]);
      final d = ballPos - tailPos-100;

      final dist = sqrt(d.x * d.x + d.y * d.y);
      if (d.y > 0) {
        ball!.y -= d.y;
        ballVelocity.y -= 0.1;
      }
      // if (dist < 40) {
      //   ballIsFalling = false;
      // }
      else {
        ballVelocity.y = 0.1;

        ballIsFalling = true;
        ball!.y += 0.1;
      }
      ball!.y += ballVelocity.y;
    }

    super.update(dt);
  }
}

class CustomRiveComponent extends RiveComponent
    with HasGameRef, Tappable, Draggable {
  final Artboard artboard;

  CustomRiveComponent({required this.artboard})
      : super(
            artboard: artboard, size: Vector2(artboard.width, artboard.height));

  late OneShotAnimation controller;
  late Fill fill;
  Vector3 velocity = Vector3.zero();
  // static late Vector2 screenSize;

  @override
  Future<void>? onLoad() {
    controller = OneShotAnimation('demo', autoplay: false);
    // var e = controller.onStop!();
    artboard.addController(controller);

    return super.onLoad();
  }
}
