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
}

class MyGame extends FlameGame with HasTappables, HasDraggables {
  List<Player> players = <Player>[];
  // Player player = Player();
  Rect? constraint;
  Vector2? court;
  Shape? ball;
  double? ballRadius;
  static double frameRate = 60;
  double y = 0;
  double x = 0;
  Vector2 ballVelocity = Vector2(0, 0);
  Vector2 ballSpawn = Vector2(150, -200);
  bool isCharging = false;
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
    Artboard artboard = await loadArtboard(RiveFile.asset('assets/beach.riv'));
    CustomRiveComponent component = CustomRiveComponent(artboard: artboard);
    var diff = Vector2(artboard.width - size.x, artboard.height - size.y);

    component.position = -diff / 2;
    add(component);
    int targetCount = 0;
    int tailCount = 0;
    artboard.forEachComponent((child) {
      switch (child.name) {
        case 'target':
          // target = child as Shape;
          (child as Shape).opacity = 0;
          if (players.length <= targetCount) {
            players.add(Player());
          }
          players[targetCount].target = child;
          ++targetCount;
          // player.target = child as Shape;
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
  void onDragStart(int i, DragStartInfo info) {
    super.onDragStart(i, info);
  }

  @override
  void onDragUpdate(int i, DragUpdateInfo info) {
    super.onDragUpdate(i, info);
    var player = players[activeIndex];
    var target = player.target;
    final tailY = player.tail.worldTranslation.values[1];
    final dy = info.delta.game.x * (activeIndex.isEven ? 1 : -1);
    target.y = target.y + dy;
    target.x -= info.delta.game.y;
    if (constraint == null) {
      return;
    }
    print(target.worldTranslation);
    if (target.worldTranslation.values[1] < tailY + constraint!.top ||
        target.worldTranslation.values[1] > tailY + constraint!.bottom) {
      print(tailY);

      // target.y -= 1 * dy;
    }
  }

  @override
  void update(double dt) {
    if (ball == null) {
      return;
    }
    var i = 0;
    ballIsFalling = true;
    Vector2 ballPos = Vector2(
        ball!.worldTranslation.values[0], ball!.worldTranslation.values[1]);
    for (var p in players) {
      Vector2 tailPos = Vector2(
          p.tail.worldTranslation.values[0], p.tail.worldTranslation.values[1]);
      if (p.tailPrevious == null || p.tailPrevious == Vector2.zero()) {
        p.tailPrevious = tailPos;
        continue;
      }

      final d = ballPos - tailPos;
      final dist = sqrt(d.x * d.x + d.y * d.y);
      if (d.x.abs() > 50) {
        continue;
      }

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
    }
    ballVelocity.x *= 0.98;
    if (ballIsFalling) {
      ballVelocity.y += 0.2;
      if (ballPos.y >= size.y * 0.8) {
        ballVelocity = Vector2.zero();
        ball!.opacity -= 0.01;
        if (ball!.opacity <= 0) {
          ball!.opacity = 1;
          ball!.x = ballSpawn.x;
          ball!.y = ballSpawn.y;
        }
      }
    }
    ball!.x += ballVelocity.x;
    ball!.y += ballVelocity.y;
    super.update(dt);
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
}
