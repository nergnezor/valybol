import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
// import 'package:motion_sensors/motion_sensors.dart';
import 'package:rive/rive.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/bones/root_bone.dart';
import 'package:rive/src/rive_core/shapes/rectangle.dart';
import 'package:rive/src/rive_core/shapes/ellipse.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/constraints/translation_constraint.dart';

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

class Player {
  late Shape target;
  late Node tail;
  Vector2 tailPrevious = Vector2.zero();
  int charge = 0;
  bool isCharging = false;
  double angle = 0;
  Vector2 targetSpawn = Vector2.zero();
}

class MyGame extends FlameGame with HasTappables, HasDraggables {
  List<Player> players = <Player>[];
  Player? player;
  Rect? constraint;
  Vector2? court;
  Shape? ball;
  double? ballRadius;
  static double frameRate = 60;
  double y = 0;
  double x = 0;
  Vector2 ballVelocity = Vector2(0, 0);
  Vector2 ballSpawn = Vector2(150, -200);
  Vector2 targetSpawn = Vector2(-300, -200);
  int activeIndex = 0;
  @override
  Color backgroundColor() => const Color(0xff471717);
  bool ballIsFalling = true; //

  @override
  Future<void> onLoad() async {
    // BubbleComponent.screenSize = size;
    print('Load Rive artboard...');
    loadRive(0, 0);
    await super.onLoad();
  }

  Future<void> loadRive(double xPosition, double yPosition) async {
    Artboard artboard =
        await loadArtboard(RiveFile.asset('assets/valybol.riv'));
    CustomRiveComponent component = CustomRiveComponent(artboard: artboard);
    var diff = Vector2(artboard.width - size.x, artboard.height - size.y);
    component.position = -diff / 2;
    add(component);
    Artboard artboard2 = await loadArtboard(RiveFile.asset('assets/whale.riv'));
    Artboard artboard3 = await loadArtboard(RiveFile.asset('assets/whale.riv'));
    CustomRiveComponent component2 = CustomRiveComponent(artboard: artboard2);
    CustomRiveComponent component3 = CustomRiveComponent(artboard: artboard3);
    add(component2);
    add(component3);

    int targetCount = 0;
    int tailCount = 0;
    artboard2.forEachComponent((child) {
      switch (child.name) {
        case 'target':
          // (child as Shape).opacity = 0;
          if (players.length <= targetCount) {
            players.add(Player());
          }
          players[targetCount].target = child as Shape;

          ++targetCount;
          print(child.name);

          if (constraint == null) {
            final c = child.children.whereType<TranslationConstraint>().single;
            constraint =
                Rect.fromLTRB(c.minValue, c.minValueY, c.maxValue, c.maxValueY);
            return;
          }
          break;

        case 'rectangle':
          court =
              Vector2((child as Rectangle).width, (child as Rectangle).height);
          print(court!.toString());
          break;
        case 'tail':
          if (players.length <= tailCount) {
            players.add(Player());
          }
          players[tailCount].tail = child as Node;
          ++tailCount;
          print(child.name);
          break;
        case 'ball':
          ball = child as Shape;
          ball!.x = ballSpawn.x;
          ball!.y = ballSpawn.y;
          print(child.name);
          break;
        case 'ball ellipse':
          ballRadius = (child as Ellipse).radiusX;
          print(child.name);
          break;
        case 'val':
          var e = child;
          print(child.name);
          break;
      }
    });
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    activeIndex =
        (info.eventPosition.game.x / (size.x / 2)).floor(); // ? 1 : 0;
    player = players[activeIndex];

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
    player?.isCharging = false;
    // player?.angle = 0;
    print('drag end: ');
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    super.onDragUpdate(i, info);
    var player = players[activeIndex];
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

    if (ball == null) {
      return;
    }
    return;
    var i = 0;
    ballIsFalling = true;
    Vector2 ballPos = Vector2(
        ball!.worldTranslation.values[0], ball!.worldTranslation.values[1]);
    for (var p in players) {
      if (!p.isCharging && p.charge > 0) {
        final dCharge = min(10, p.charge);
        // p.charge -= dCharge;
        // ballVelocity.y -= dCharge / 10;
        // ballVelocity.x += p.angle * 0.01;
        // p.target.x += 10;
        // print()
        final dTarget = p.targetSpawn - Vector2(p.target.x, p.target.y);
        print(acos(dTarget.y / dTarget.x));
        // p.target.x += acos(dTarget.y / dTarget.x);
        p.target.x -= dCharge * dTarget.y / 200;
        // p.target.y -= dCharge * dTarget.x / 100;
        // ballVelocity
      }
      p.target.x = p.target.x.clamp(constraint!.left, constraint!.right);
      p.target.y = p.target.y.clamp(constraint!.top, constraint!.bottom);
      Vector2 tailPos = Vector2(
          p.tail.worldTranslation.values[0], p.tail.worldTranslation.values[1]);
      if (p.tailPrevious == Vector2.zero()) {
        p.tailPrevious = tailPos;
        continue;
      }

      final d = ballPos - tailPos;
      final dist = sqrt(d.x * d.x + d.y * d.y);
      if (dist > 50) {
        continue;
      }
      ball!.x -= d.x / d.x.abs();
      final tailMovement = tailPos - p.tailPrevious;

      if (ballPos.y + ballRadius! > tailPos.y) {
        ball!.worldTranslation.values[1] =
            p.tail.worldTranslation.values[1] - ballRadius!;
        if (ballVelocity.y > 0) {
          ballVelocity.y = 0;
        }
        ballVelocity.y = min(0, ballVelocity.y);
        ballVelocity += tailMovement * dt * 10;
        ballIsFalling = false;
      }

      p.tailPrevious = tailPos;
      i += 1;
      final dTarget = p.targetSpawn -
          Vector2(p.target.worldTranslation.values[0],
              p.target.worldTranslation.values[1]);
      // p.target.x -= dTarget.y / 10;
      // p.target.y -= dTarget.x / 10;
    }
    ballVelocity.x *= 0.98;
    if (ballIsFalling) {
      ballVelocity.y += 0.3;
      if (ballPos.y >= court!.y) {
        ballVelocity = Vector2.zero();
        ball!.opacity -= 0.05;
        if (ball!.opacity <= 0) {
          ball!.opacity = 1;
          ball!.x = ballSpawn.x;
          ball!.y = ballSpawn.y;
        }
      }
    }

    ball!.x += ballVelocity.x;
    ball!.y += ballVelocity.y;
  }
}

class CustomRiveComponent extends RiveComponent
    with HasGameRef, Tappable, Draggable {
  final Artboard artboard;

  CustomRiveComponent({required this.artboard})
      : super(
            artboard: artboard, size: Vector2(artboard.width, artboard.height));

  late OneShotAnimation controller;
  late Fill fill;
  Vector3 velocity = Vector3.zero();

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }
}
