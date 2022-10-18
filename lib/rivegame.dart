import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
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
  await addPlayer(size, gamestate, components);
  // await addPlayer(size, gamestate, components);

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
        child.x += 150;
        s.ball.spawn = child.translation;
        // s.ball.spawn.y = child.y;
        break;
      case 'ball ellipse':
        s.ball.radius = (child as Ellipse).radiusX;
        break;
      case 'val':
        s.player?.rootBone = child as RootBone;
        break;
    }
  });

  if (a.name == 'whale') {
    playerCount++;
    if (playerCount == 2) {
      // s.player?.rootBone?.x -= 250;
      s.player?.component.x += a.width;
      s.player?.component.flipHorizontally();

      // s.player?.component.scale.x = -1;
      // s.player?.rootBone?.scaleY *= -1;
      // s.player?.target?.x *= -1;
      // s.player?.constraint = Rect.fromLTRB(
      //     s.player!.constraint!.left - 50,
      //     s.player!.constraint!.top,
      //     s.player!.constraint!.right - 50,
      //     s.player!.constraint!.bottom);
      s.player?.invertX = true;
      // s.player?.constraint.
      // s.player?.rootBone?.x += 150;
    } else {
      // s.player?.rootBone?.x -= 150;
    }
    s.player?.targetSpawn =
        s.player!.target!.translation; // + Vec2D.fromValues(50, 120);
  }
}
