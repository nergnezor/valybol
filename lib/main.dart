import 'dart:io';
import 'dart:math';
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
  Gamestate g = Gamestate();

  @override
  Color backgroundColor() => const Color(0xff471717);

  @override
  Future<void> onLoad() async {
    final components = await loadRive(size, g);
    addAll(components);
    await super.onLoad();
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    g.player?.isCharging = false;
    final d = g.player!.target!.translation - g.player!.targetSpawn;
    if (!d.x.isNaN) g.player!.xFactor = d.x / d.y;
    g.player!.speed.y = 0;
    // print(g.player!.xFactor);
    super.onDragEnd(pointerId, info);
    g.ball.ballIsFalling = true;
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    int activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
    g.player = g.players[activeIndex];
    g.player?.xFactor = 0;

    super.onDragStart(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    final p = g.player;
    p?.target!.x += info.delta.game.x;
    if (info.delta.game.y >= 0) {
      p?.isCharging = true;
      p?.charge += info.delta.game.y;
      p?.target!.y += info.delta.game.y;

      // p?.angle += info.delta.game.x;
      // p.rootBone.rotation += info.delta.game.x / 100;
    }
    p?.target?.y = p.target!.y.clamp(g.constraint!.top, g.constraint!.bottom);
    p?.target?.x = p.target!.x.clamp(g.constraint!.left, g.constraint!.right);
    super.onDragUpdate(pointerId, info);
  }

  @override
  void update(double dt) {
    g.ball.update(dt, g);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // _drawVerticalLines(canvas);
  }

  void _drawVerticalLines(Canvas c) {
    for (var p in g.players) {
      var offset = p.component.toRect();
      offset = offset.translate(47, 128);
      final current = Offset(p.target!.x, p.target!.y) + offset.topLeft;
      final target = Offset(p.targetSpawn.x, p.targetSpawn.y) + offset.topLeft;
      c.drawLine(current, target, Paint()..color = Colors.red);
      c.drawCircle(target, 10, Paint()..color = Colors.red);
    }
  }
}
