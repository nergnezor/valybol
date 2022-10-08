import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
// import 'package:motion_sensors/motion_sensors.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'gamestate.dart';
import 'rivegame.dart';

void main() {
  print('start main');
  runApp(GameWidget(
    game: MyGame(),
  ));
  if (!kIsWeb && Platform.isAndroid) {
    try {
      FlutterDisplayMode.setHighRefreshRate();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {}
  }
}

class MyGame extends FlameGame with HasTappables, HasDraggables {
  Gamestate gamestate = Gamestate();

  @override
  Color backgroundColor() => const Color(0xff471717);

  @override
  Future<void> onLoad() async {
    final components = await loadRive(size, gamestate);
    addAll(components);
    await super.onLoad();
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    int activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
    gamestate.player = gamestate.players[activeIndex];
  }

  @override
  void onDragEnd(int i, DragEndInfo info) {
    super.onDragEnd(i, info);
    gamestate.player?.isCharging = false;
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    super.onDragUpdate(i, info);
    var target = gamestate.player?.target;

    if (info.delta.game.y > 0) {
      gamestate.player?.isCharging = true;
      ++gamestate.player?.charge;
      target!.x -= info.delta.game.y;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    gamestate.ball.updateBall(dt, gamestate);
  }
}
