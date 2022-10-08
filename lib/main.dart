// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
// import 'package:motion_sensors/motion_sensors.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'ball.dart';
import 'gamestate.dart';
import 'rivegame.dart';
import 'player.dart';

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
  // static double frameRate = 60;
  // double y = 0;
  // double x = 0;
  // Vector2 targetSpawn = Vector2(-0, -000);
  int activeIndex = 0;
  Gamestate gamestate = Gamestate();
  @override
  Color backgroundColor() => const Color(0xff471717);

  @override
  Future<void> onLoad() async {
    // BubbleComponent.screenSize = size;
    print('Load Rive artboard...');
    final components = await loadRive(size, gamestate);
    addAll(components);
    await super.onLoad();
    print('loaded');
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
    gamestate.player = gamestate.players[activeIndex];

    print('tap down: ' + pointerId.toString());
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
    activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
    print('tap up: ' + pointerId.toString());
  }

  @override
  void onDragEnd(int i, DragEndInfo info) {
    super.onDragEnd(i, info);
    gamestate.player?.isCharging = false;
    // player?.angle = 0;
    print('drag end: ');
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    super.onDragUpdate(i, info);
    var player = gamestate.players[activeIndex];
    var target = player.target;
    // final tailY = player.tail.worldTranslation.values[1];

    if (info.delta.game.y > 0) {
      player.isCharging = true;
      ++player.charge;
      target.x -= info.delta.game.y;
    }
    final dx = info.delta.game.x * (activeIndex.isEven ? 1 : -1);
    player.angle += dx;
    // print(player.angle);
    target.y = target.y + dx;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // return;
    gamestate.ball.updateBall(dt, gamestate);
  }
}
