import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart' show Colors;
// import 'package:flutter/material.dart';
import 'package:rive/components.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/gamestate.dart';
import 'package:valybol/player.dart';
// ignore: implementation_imports
import 'package:rive/src/rive_core/bones/root_bone.dart';
// ignore: implementation_imports
import 'package:rive/src/rive_core/shapes/rectangle.dart';
// ignore: implementation_imports
import 'package:rive/src/rive_core/shapes/ellipse.dart';
// ignore: implementation_imports
import 'package:rive/src/rive_core/constraints/translation_constraint.dart';
import 'package:rive/src/rive_core/animation/state_machine_bool.dart';
import 'package:valybol/settings.dart';

class CustomRiveComponent extends RiveComponent with Draggable {
  @override
  // final Artboard artboard;
  final Gamestate gamestate;

  CustomRiveComponent(artboard, this.gamestate)
      : super(
            artboard: artboard, size: Vector2(artboard.width, artboard.height));
  late StateMachineController controller;
  late Fill fill;

  @override
  Future<void>? onLoad() {
    controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')!;

    artboard.addController(controller);
    parseArtboard(artboard, gamestate);
    return super.onLoad();
  }
}

Future<CustomRiveComponent> addRiveArtboard(
    String path, size, Gamestate gamestate) async {
  Artboard artboard = await loadArtboard(RiveFile.asset(path));
  final component = CustomRiveComponent(artboard, gamestate);
  if (gamestate.scale == 0) gamestate.scale = 7 * size.x / artboard.width;
  component.scale = Vector2.all(gamestate.scale);
  component.position.x = (size.x - gamestate.scale * artboard.width) / 2;
  component.position.y = (size.y - gamestate.scale * artboard.height) / 2;
  return component;
}

Future<List<CustomRiveComponent>> loadRive(
    Vector2 size, Gamestate gamestate) async {
  final components = <CustomRiveComponent>[];
  var c = await addRiveArtboard('assets/valybol.riv', size, gamestate);
  components.add(c);
  await addPlayer(size, gamestate, components);
  await addPlayer(size, gamestate, components);

  return components;
}

Future<void> addPlayer(
    Vector2 size, Gamestate s, List<CustomRiveComponent> components) async {
  final player = Player();
  s.players.add(player);
  s.player = player;
  player.component = await addRiveArtboard('assets/whale.riv', size, s);
  components.add(player.component);
}

int playerCount = 0;
void parseArtboard(Artboard a, Gamestate g) {
  g.player = g.players[playerCount];
  final p = g.player!;
  a.forEachComponent((child) {
    switch (child.name) {
      case 'target':
        child = child as Node;
        // child.y += 200;
        if (!Settings.showTargets) {
          child.opacity = 0;
        }
        p.target = child;
        final c = child.children.whereType<TranslationConstraint>().single;
        p.constraint =
            Rect.fromLTRB(c.minValue, c.minValueY, c.maxValue, c.maxValueY);
        c.strength = 0;
        break;
      case 'rectangle':
        child = child as Rectangle;
        g.court = Vec2D.fromValues(child.width, child.height);
        break;
      case 'tail':
        p.tail = child as Node;
        break;
      case 'ball':
        g.ball.shape = child as Shape;
        child.x -= 100;
        child.x -= 200;
        g.ball.spawn = child.translation;
        break;
      case 'ball ellipse':
        g.ball.radius = (child as Ellipse).radiusX;
        break;
      case 'val':
        p.rootBone = child as RootBone;
        break;
      case 'body':
        p.fill = (child as Node).children.whereType<Fill>().last;
        break;
    }
  });

  if (a.name == 'whale') {
    // p.component.scale = Vector2.all(0.7);
    playerCount++;
    p.offset = Vec2D.fromValues(p.component.position.x - (g.scale - 1) * 200,
        p.component.position.y + (g.scale - 1) * 120);
    p.component.position.y += 100 * g.scale;
    if (playerCount == 2) {
      p.component.flipHorizontallyAroundCenter();
      p.fill?.paint.color = Colors.black.withOpacity(0);
      p.component.position.x += 200 * g.scale;
      p.offset.x += p.component.width * g.scale + (g.scale - 1) * 400;
      p.clampStart = 0;
      p.clampEnd = 150;
    } else {
      p.component.position.x -= 200 * g.scale;
      p.clampStart = -100;
      p.clampEnd = 100;
    }
    p.targetSpawn = p.target!.translation;
  }
}
