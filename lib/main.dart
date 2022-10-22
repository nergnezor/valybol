import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'gamestate.dart';
import 'rivegame.dart';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer? player;
Future<void> main() async {
  print('start main');
  runApp(GameWidget(
    game: MyGame(),
  ));
  player = AudioPlayer();
  if (!kIsWeb && Platform.isAndroid) {
    try {
      FlutterDisplayMode.setHighRefreshRate();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {}
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.landscapeLeft,
  ]);
}

class MyGame extends FlameGame with HasDraggables {
  Gamestate g = Gamestate();
  bool waitToDropBall = false;
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
    if (g.p.isCharging) {
      g.p.isCharging = false;
      g.p.component.controller.inputs.first.change(true);
      if (g.p.hasBall) {
        g.p.hasBall = false;
        g.ball.velocity.x = 3 * g.ball.shape!.x;
        g.p.isCharging = false;
        g.component.controller.inputs.last.change(true);
      }
    }
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (!g.p.isCharging) {
      g.p.component.controller.inputs.last.change(true);
      if (g.ball.velocity.y == 0 && g.p.hasBall) {
        g.component.controller.inputs.first.change(true);
        g.ball.velocity.x = 0;
      }
      g.p.isCharging = true;
    }
    startBgmMusic();
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    final p = g.p;
    p.target!.y += info.delta.game.x;
    if (p.target!.y < p.constraint!.top || p.target!.y > p.constraint!.bottom) {
      p.target?.y = p.target!.y.clamp(p.constraint!.top, p.constraint!.bottom);
      p.rootBone?.x += info.delta.game.x;
      p.rootBone?.x = p.rootBone!.x.clamp(-300, 300);

      // return;
    }
    if (!p.isCharging || !p.hasBall) return;
    g.ball.shape!.x = p.target!.y + p.rootBone!.x;

    super.onDragUpdate(pointerId, info);
  }

  @override
  void update(double dt) {
    if (g.ball.velocity.y == 0 && !g.p.hasBall && g.p.isCharging) {
      final dBall = g.ball.shape!.x - g.p.target!.y - g.p.rootBone!.x;
      if (dBall.abs() < 50) {
        // print(dBall);
        g.p.hasBall = true;
        g.component.controller.inputs.first.change(true);
        g.ball.velocity.x = 0;
      }
    }
    g.ball.update(dt, g);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //_drawVerticalLines(canvas);
  }

  // void _drawVerticalLines(Canvas c) {
  //   for (var p in g.players) {
  //     var offset = p.component.toRect();
  //     offset = offset.translate(47, 128);
  //     final current = Offset(p.target!.x, p.target!.y) + offset.topLeft;
  //     final target = Offset(p.targetSpawn.x, p.targetSpawn.y) + offset.topLeft;
  //     c.drawLine(current, target, Paint()..color = Colors.red);
  //     c.drawCircle(target, 10, Paint()..color = Colors.red);
  //   }
  // }

  Future<void> startBgmMusic() async {
    if (player?.state == PlayerState.playing) {
      return;
    }
    togglePlayerInput(true);
    player?.onPlayerComplete.listen((event) {
      togglePlayerInput(false);
    });
    await player?.play(AssetSource('SalmonLake91bpm.ogg'));
  }

  void togglePlayerInput(bool b) {
    // for (var p in g.players) {
    g.p.component.controller.inputs.last.change(b);
    // }
  }
}
