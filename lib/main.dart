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
    gamestate.player?.isCharging = false;
    double dir =
        gamestate.players.indexOf(gamestate.player as Player) == 0 ? 1 : -1;
    gamestate.ball.ballVelocity.x = gamestate.player!.angle * 2;
    print(gamestate.player!.angle);
    super.onDragEnd(i, info);
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
    final p = gamestate.player;
    if (info.delta.game.y >= 0) {
      if (p!.target!.y > gamestate.constraint!.bottom) {
        return;
      }
      p.isCharging = true;
      p.charge += info.delta.game.y;
      p.target!.y += info.delta.game.y;

      p.angle += info.delta.game.x;
      p.rootBone.rotation += info.delta.game.x / 100;
      // p.rootBone.rotation = p.angle;
    }
    super.onDragUpdate(pointerId, info);
  }

  @override
  void update(double dt) {
    gamestate.ball.update(dt, gamestate);
    super.update(dt);
  }
}
