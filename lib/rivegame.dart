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
  // late OneShotAnimation ani;
  late Fill fill;

  @override
  Future<void>? onLoad() {
    controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')!;

    bool? _levelInput = controller.findInput<bool>('dress')?.change(true);
    artboard.addController(controller);
    parseArtboard(artboard, gamestate);
    return super.onLoad();
  }
}

Future<CustomRiveComponent> addRiveArtboard(
    String path, size, Gamestate gamestate) async {
  Artboard artboard = await loadArtboard(RiveFile.asset(path));
  final component = CustomRiveComponent(artboard, gamestate);
  component.position.x = (size.x - artboard.width) / 2;
  component.position.y = (size.y - artboard.height) / 2;
  return component;
}

Future<List<CustomRiveComponent>> loadRive(
    Vector2 size, Gamestate gamestate) async {
  final components = <CustomRiveComponent>[];
  var c = await addRiveArtboard('assets/valybol.riv', size, gamestate);
  components.add(c);
//  Artboard artboard = await loadArtboard(RiveFile.asset(path));
  // final component =
  //     CustomRiveComponent(c.artboard.activeNestedArtboards.first, gamestate);
  // component.position.x = (size.x - artboard.width) / 2;
  // component.position.y = (size.y - artboard.height) / 2;
  //     c.artboard.activeNestedArtboards.first as String, size, gamestate);
  // final component = CustomRiveComponent(
  //     c.artboard.activeNestedArtboards.first.artboard, gamestate);
  // components.add(component);
  // components.add(component);
  // component.position.x = (size.x  / 2;
  // component.position.y = (size.y - artboard.height) / 2;
  // c.artboard.activeNestedArtboards.first.opacity = 0;

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
void parseArtboard(Artboard a, Gamestate s) {
  s.player = s.players[playerCount];
  a.forEachComponent((child) {
    switch (child.name) {
      case 'target':
        child = child as Node;
        // child.y += 200;
        if (!Settings.showTargets) {
          child.opacity = 0;
        }
        s.player?.target = child;
        final c = child.children.whereType<TranslationConstraint>().single;
        s.player?.constraint =
            Rect.fromLTRB(c.minValue, c.minValueY, c.maxValue, c.maxValueY);
        c.strength = 0;
        break;
      case 'rectangle':
        child = child as Rectangle;
        s.court = Vec2D.fromValues(child.width, child.height);
        break;
      case 'tail':
        s.player?.tail = child as Node;
        break;
      case 'ball':
        s.ball.shape = child as Shape;
        // child.x += 150;
        s.ball.spawn = child.translation;
        // s.ball.spawn.y = child.y;
        break;
      case 'ball ellipse':
        s.ball.radius = (child as Ellipse).radiusX;
        break;
      case 'val':
        s.player?.rootBone = child as RootBone;
        break;
      case 'body':
        s.player?.fill = (child as Node).children.whereType<Fill>().last;
        break;
    }
  });

  if (a.name == 'whale') {
    playerCount++;
    s.player!.component.position.y += 150;
    // s.player!.component.position.x -= 250;
    if (playerCount == 2) {
      s.player?.fill?.paint.color = Colors.black.withOpacity(0);
      s.player!.component.flipHorizontallyAroundCenter();
      // s.player!.component.artboard.x += 500;

      // s.player!.component.position.x += 500;
    } else {
      s.player!.component.position.x -= 250;
    }
    s.player!.offset = Vec2D.fromValues(s.player!.component.position.x,
        s.player!.component.position.y - 250 - 150);
    s.player?.targetSpawn = s.player!.target!.translation;
  }
}
