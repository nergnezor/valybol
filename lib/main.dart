import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
// import 'package:motion_sensors/motion_sensors.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:rive/math.dart';
import 'package:valybol/player.dart';
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

class MyGame extends FlameGame with HasDraggables {
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
  void onDragEnd(int i, DragEndInfo info) {
    super.onDragEnd(i, info);
    gamestate.player?.isCharging = false;
    double dir =
        gamestate.players.indexOf(gamestate.player as Player) == 0 ? 1 : -1;
    gamestate.ball.ballVelocity.x = 180 * dir;
  }

  @override
  void onDragStart(int i, DragStartInfo info) {
    int activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
    gamestate.player = gamestate.players[activeIndex];

    super.onDragStart(i, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (info.delta.game.y >= 0) {
      gamestate.player?.isCharging = true;
      gamestate.player?.charge += info.delta.game.y;
      gamestate.player?.target!.y += info.delta.game.y;
    }
    super.onDragUpdate(pointerId, info);
  }

  @override
  void update(double dt) {
    gamestate.ball.update(dt, gamestate);
    super.update(dt);
  }
}
