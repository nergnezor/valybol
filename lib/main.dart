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

void main() {
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
  late Shape ball;
  static double frameRate = 60;
  double y = 0;
  double x = 0;

  @override
  Color backgroundColor() => const Color(0xff471717);

  @override
  Future<void> onLoad() async {
    // BubbleComponent.screenSize = size;
    createBubble(0, 0);
    await super.onLoad();
  }

  Future<void> createBubble(double xPosition, double yPosition) async {
    Artboard artboard = await loadArtboard(RiveFile.asset('assets/beach.riv'));
    BubbleComponent component = BubbleComponent(artboard: artboard);
    component.position = Vector2(xPosition - 200, yPosition - 500);
    add(component);
    artboard.forEachComponent((child) {
      if (child.name == 'ball') {
        print("stst");
        ball = child as Shape;
        // fill = child as Fill;
      }
    });
  }

  @override
  void onDragStart(int i, DragStartInfo info) {
    super.onDragStart(i, info);
    print('handled 2?' + info.toString());
    // if (info.handled) {
    //   return;
    // }
    ball.x = info.eventPosition.global.x;
    ball.y = info.eventPosition.global.y;

    // createBubble(info.eventPosition.game.x, info.eventPosition.game.y);
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    super.onDragUpdate(i, info);

    x += info.delta.game.x; // != 0 || info.delta.game.y != 0) {
    y += info.delta.game.y;
    info.handled = true;
  }

  @override
  void update(double dt) {
    // y += 1;
    // if (y > size.y) {
    //   y = 0;
    // }
    super.update(dt);
  }
}

class BubbleComponent extends RiveComponent
    with HasGameRef, Tappable, Draggable {
  final Artboard artboard;
  BubbleComponent({required this.artboard})
      : super(artboard: artboard, size: Vector2.all(1500));

  late OneShotAnimation controller;
  late Fill fill;
  Vector3 velocity = Vector3.zero();
  // static late Vector2 screenSize;
  double lifeTime = 0;
  double maxVelocity = 0;
  // bool growing = true;
  // AccelerometerEvent? acc;
  // GyroscopeEvent? gyro;
  // Vector3 acc = Vector3.zero();
  // Vector3 gyro = Vector3.zero();
  // @override
  // Future<void>? onLoad() {
  //   controller = OneShotAnimation('Idle', autoplay: true);
  //   artboard.addController(controller);
  //   artboard.forEachComponent((child) {
  //     if (child.name == 'fyllning') {
  //       fill = child as Fill;
  //     }
  //   });
  //   if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
  //     motionSensors.accelerometerUpdateInterval = 5000;
  //     motionSensors.accelerometer.listen((AccelerometerEvent event) {
  //       acc.setValues(event.x, event.y, event.z);
  //     });
  //     motionSensors.gyroscopeUpdateInterval = 5000;
  //     motionSensors.gyroscope.listen((GyroscopeEvent event) {
  //       gyro.setValues(event.x, event.y, event.z);
  //     });
  //   }
  // return super.onLoad();
  // }

  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   return;
  // }

  // @override
  // bool onDragStart(DragStartInfo info) {
  //   info.handled = true;
  //   return false;
  // }

  // @override
  // bool onDragEnd(DragEndInfo info) {
  //   // growing = false;
  //   return false;
  // }

  // @override
  // bool onDragUpdate(DragUpdateInfo info) {
  //   position = info.eventPosition.game - size / 2;
  //   velocity.xy = (info.delta.game / 60);

  //   return true;
  // }

  // void float(double dt) {
  //   position += Vector2.all(sin(lifeTime * 3) * dt * 10);
  // }
}
