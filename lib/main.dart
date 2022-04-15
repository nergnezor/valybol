import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void set120Hz() async {
  var modes = await FlutterDisplayMode.supported;
  modes.forEach(print);
  try {
    await FlutterDisplayMode.setPreferredMode(modes.last);

    /// e.code =>
    /// noAPI - No API support. Only Marshmallow and above.
    /// noActivity -  Activity is not available. Probably app is in background
  } on PlatformException {
    return;
  }
  MyGame.frameRate = modes.last.refreshRate;
}

void main() {
  runApp(GameWidget(
    game: MyGame(),
  ));
  FlutterDisplayMode.setHighRefreshRate();
  // try {
  //   if (!kIsWeb && Platform.isAndroid) {
  //     set120Hz();
  //   }
  // } catch (e) {}
}

class MyGame extends FlameGame with HasTappables, HasDraggables {
  static double frameRate = 60;

  @override
  Color backgroundColor() => const Color(0xff171717);

  @override
  Future<void> onLoad() async {
    BubbleComponent.screenSize = size;
    await super.onLoad();
  }

  Future<void> createBubble(double xPosition, double yPosition) async {
    Artboard artboard =
        await loadArtboard(RiveFile.asset('assets/bubble_still.riv'));
    BubbleComponent component = BubbleComponent(artboard: artboard);
    component.position = Vector2(xPosition, yPosition) - component.size / 2;
    add(component);
  }

  @override
  void onTapUp(int i, TapUpInfo info) {
    super.onTapUp(i, info);
    print('handled 2?' + info.handled.toString());
    if (info.handled) {
      return;
    }
    createBubble(info.eventPosition.game.x, info.eventPosition.game.y);
  }
}

class BubbleComponent extends RiveComponent
    with HasGameRef, Tappable, Draggable {
  final Artboard artboard;
  BubbleComponent({required this.artboard})
      : super(
            artboard: artboard,
            size: Vector2.all(Random().nextDouble() * 100 + 100));

  late OneShotAnimation controller;
  late Fill fill;
  Vector2 velocity = Vector2.zero();
  static late Vector2 screenSize;
  double lifeTime = 0;

  @override
  Future<void>? onLoad() {
    controller = OneShotAnimation('Idle', autoplay: true);
    artboard.addController(controller);
    artboard.forEachComponent((child) {
      if (child.name == 'fyllning') {
        fill = child as Fill;
      }
    });
    return super.onLoad();
  }

  @override
  void update(double dt) {
    lifeTime += dt;
    edgeBounce();
    float(dt);
    super.update(dt);
    position += velocity * dt * 10000;
    velocity *= 0.99;
    position.y += dt * 10;
  }

  void edgeBounce() {
    //  bounce
    if (position.x < 0) {
      position.x = 0;
      velocity.x = -velocity.x;
    }
    if (position.x > screenSize.x - size.x) {
      position.x = screenSize.x - size.x;
      velocity.x = -velocity.x;
    }
    if (position.y < 0) {
      position.y = 0;
      velocity.y = -velocity.y;
    }
    if (position.y > screenSize.y - size.y) {
      position.y = screenSize.y - size.y;
      velocity.y = -velocity.y;
    }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    info.handled = true;

    if (!controller.isActive) {
      fill.paint.color = Colors.red.withOpacity(0.25);
      controller.isActive = true;
    } else {
      gameRef.remove(this);
    }
    return true;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    position = info.eventPosition.game - size / 2;
    velocity = (info.delta.game / 60);

    return true;
  }

  void float(double dt) {
    position += Vector2.all(sin(lifeTime * 1) * dt * 10);
  }
}
