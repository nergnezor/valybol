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
    // gamestate.player!.component.controller
    //     .pointerDown(Vec2D.fromValues(200, 300));
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
    print('on tap up');

    // gamestate.player!.component.controller
    //     .pointerUp(Vec2D.fromValues(200, 300));
  }

  @override
  void onDragEnd(int i, DragEndInfo info) {
    super.onDragEnd(i, info);
    gamestate.player?.isCharging = false;
    double dir =
        gamestate.players.indexOf(gamestate.player as Player) == 0 ? 1 : -1;
    gamestate.ball.ballVelocity.x = 180 * dir;
    print('falling');
    // gamestate.player!.component.controller
    //     .pointerUp(Vec2D.fromValues(200, 300));
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    super.onDragUpdate(i, info);
    // var target = gamestate.player?.target;

    if (info.delta.game.y >= 0) {
      gamestate.player?.isCharging = true;
      gamestate.player?.charge += info.delta.game.y;
      gamestate.player?.target!.y += info.delta.game.y;
      // target!.x -= info.delta.game.y;
    }
  }


  @override
  void update(double dt) {
    super.update(dt);
    gamestate.ball.update(dt, gamestate);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // _drawVerticalLines(canvas);
  }

  void _drawVerticalLines(Canvas c) {
    for (var p in gamestate.players) {
      final offset = p.component.toRect();
      final current =
          Offset(p.target!.worldTranslation.x, p.target!.worldTranslation.y) +
              offset.topLeft;
      final target = Offset(p.targetSpawn.x, p.targetSpawn.y);
      c.drawLine(current, target, Paint()..color = Colors.red);
    }
  }
}
