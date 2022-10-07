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
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/bones/root_bone.dart';
import 'package:rive/src/rive_core/shapes/rectangle.dart';
import 'package:rive/src/rive_core/shapes/ellipse.dart';
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
  List<Shape> targets = <Shape>[];
  List<Node> tails = <Node>[];
  Vector2? court;
  Shape? ball;
  double? ballRadius;
  static double frameRate = 60;
  double y = 0;
  double x = 0;
  Vector2 ballVelocity = Vector2(0, 0);
  List<Vector2> tailPrevious = <Vector2>[];
  int activeIndex = 0;
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
          // target = child as Shape;
          (child as Shape).opacity = 0;
          targets.add(child as Shape);
          print(child.name);
          break;

        case 'rectangle':
          court =
              Vector2((child as Rectangle).width, (child as Rectangle).height);
          // var scale = size.x / court.;
          print(court!.toString());
          break;
        case 'tail':
          tails.add(child as Node);
          print(child.name);
          break;
        case 'ball':
          ball = child as Shape;
          print(child.name);
          break;
        case 'ball ellipse':
          ballRadius = (child as Ellipse).radiusX;
          print(child.name);
          break;
        case 'val':
          var e = child;

          // add(e as Component);
          print(child.name);
          break;
      }
    });

    // CustomRiveComponent component2 = CustomRiveComponent(artboard: artboard);
    // var diff = Vector2(artboard.width - size.x, artboard.height - size.y);

    // component.position = -diff / 2;
    // add(component);
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
    activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    // target?.x += info.delta.game.x; // != 0 || info.delta.game.y != 0) {
    targets[activeIndex].y = targets[activeIndex].y +
        info.delta.game.x * (activeIndex.isEven ? 1 : -1);
    targets[activeIndex].x -= info.delta.game.y;
    //info.handled = true;
    super.onDragUpdate(i, info);
  }

  @override
  void update(double dt) {
    var i = 0;
    tails.forEach((tail) {
      Vector2 ballPos = Vector2(
          ball!.worldTranslation.values[0], ball!.worldTranslation.values[1]);
      Vector2 tailPos = Vector2(
          tail.worldTranslation.values[0], tail.worldTranslation.values[1]);
      final d = ballPos - tailPos;

      final dist = sqrt(d.x * d.x + d.y * d.y);
      if (tailPrevious.length <= i) {
        tailPrevious.add(tailPos);
        return;
      }
      if (tailPos == Vector2.zero) {
        return;
      }

      final tailMovement = tailPos - tailPrevious[i];

      if (ballPos.y + ballRadius! > tailPos.y) {
        ball!.worldTranslation.values[1] =
            tail.worldTranslation.values[1] - ballRadius!;
        if (ballVelocity.y > 0) {
          ballVelocity.y = 0;
        }
        ballVelocity.y = min(0, ballVelocity.y);
        ballVelocity += tailMovement * dt * 10;
      } else {
        ballVelocity.y += 0.4;
        ballIsFalling = true;
      }
      ballVelocity.x *= 0.98;
      // ball!.x += ballVelocity.x;
      ball!.y += ballVelocity.y;

      tailPrevious[i] = tailPos;
      i += 1;
    });
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

  // @override
  // Future<void>? onLoad() {
  //   controller = OneShotAnimation('demo', autoplay: false);
  //   // var e = controller.onStop!();
  //   artboard.addController(controller);

  //   return super.onLoad();
  // }
}
