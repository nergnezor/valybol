import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
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
  void onDragEnd(int pointerId, DragEndInfo info) {
    gamestate.player?.isCharging = false;
    // gamestate.ball.ballVelocity.x = gamestate.player!.angle * 2;
    print(gamestate.player!.angle);
    super.onDragEnd(pointerId, info);
    gamestate.ball.ballIsFalling = true;
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    int activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
    gamestate.player = gamestate.players[activeIndex];

    super.onDragStart(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    final p = gamestate.player;
    p?.target!.x += info.delta.game.x;
    if (info.delta.game.y >= 0) {
      p?.isCharging = true;
      p?.charge += info.delta.game.y;
      p?.target!.y += info.delta.game.y;

      p?.angle += info.delta.game.x;
      // p.rootBone.rotation += info.delta.game.x / 100;
    }
    p?.target?.y = p.target!.y
        .clamp(gamestate.constraint!.top, gamestate.constraint!.bottom);
    p?.target?.x = p.target!.x
        .clamp(gamestate.constraint!.left, gamestate.constraint!.right);
    print(p?.angle);
    super.onDragUpdate(pointerId, info);
  }

  @override
  void update(double dt) {
    gamestate.ball.update(dt, gamestate);
    super.update(dt);
  }
}
