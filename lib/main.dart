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
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);
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
    if (!d.x.isNaN) g.player!.xFactor = -2 * d.y / d.x;
    g.player!.speed.y = 0;
    super.onDragEnd(pointerId, info);
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    int activeIndex = (info.eventPosition.game.x / (size.x / g.players.length))
        .floor(); // ? 1 : 0;
    g.player = g.players[activeIndex];
    g.player?.xFactor = 0;

    super.onDragStart(pointerId, info);
    startBgmMusic();
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    final p = g.player;
    p?.target!.y +=
        info.delta.game.x * (p.component.isFlippedHorizontally ? -1 : 1);
    if (info.delta.game.y >= 0) {
      p?.isCharging = true;
      p?.target!.x -= info.delta.game.y;
    }
    if (p!.target!.y < p.constraint!.top ||
        p.target!.y > p.constraint!.bottom) {
      p.target?.y = p.target!.y.clamp(p.constraint!.top, p.constraint!.bottom);
      // p.component.position.x += info.delta.game.x;
      p.rootBone?.x +=
          info.delta.game.x * (p.component.isFlippedHorizontally ? -1 : 1);
    }
    p.target?.x = p.target!.x.clamp(p.constraint!.left, p.constraint!.right);
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
    //_drawVerticalLines(canvas);
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
    for (var p in g.players) {
      p.component.controller.inputs.first.change(b);
    }
  }
}
