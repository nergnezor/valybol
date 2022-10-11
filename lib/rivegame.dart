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

class CustomRiveComponent extends RiveComponent with Tappable, Draggable {
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

    // if (gamestate.players.length == 2) {
    // }
    return super.onLoad();
  }
}

Future<CustomRiveComponent> addRiveArtboard(
    String path, size, Gamestate gamestate) async {
  Artboard artboard = await loadArtboard(RiveFile.asset(path));
  final component = CustomRiveComponent(artboard, gamestate);
  component.position.x = (size.x - artboard.width) / 2;
  component.position.y = (size.y - artboard.height) / 2;
  parseArtboard(artboard, gamestate);
  return component;
}

Future<List<CustomRiveComponent>> loadRive(
    Vector2 size, Gamestate gamestate) async {
  final components = <CustomRiveComponent>[];
  var c = await addRiveArtboard('assets/valybol.riv', size, gamestate);
  components.add(c);
  await addPlayer(size, gamestate, components);
  await addPlayer(size, gamestate, components);
  components.last.position.x += 300;
  gamestate.ball.shape!.x = gamestate.ball.ballSpawn.x;
  // var e = components.last..stateMachine.inputs
  //     .where((element) => element.name == "dress")
  //     .single;
  // components.last.ani = OneShotAnimation('dress', autoplay: true);

  // components.last.artboard.addController(components.last.ani);
// gamestate.player.
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

void parseArtboard(Artboard a, Gamestate s) {
  {
    a.forEachComponent((child) {
      switch (child.name) {
        case 'target':
          child = child as Shape;
          child.y += 200;
          // child.opacity = 0;
          s.player?.target = child;
          s.player?.targetSpawn = child.worldTranslation;
          if (s.constraint == null) {
            final c = child.children.whereType<TranslationConstraint>().single;
            s.constraint =
                Rect.fromLTRB(c.minValue, c.minValueY, c.maxValue, c.maxValueY);
          }
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

          s.ball.ballSpawn.x = child.x + 40;
          s.ball.ballSpawn.y = child.y;
          break;
        case 'ball ellipse':
          s.ball.ballRadius = (child as Ellipse).radiusX;
          break;
        case 'val':
          var c = child as RootBone;
          if (s.players.length.isEven) {
            c.scaleY *= -1;
            // final body =
            //     c.children.where((e) => e.name == "body").single as Shape;
            // final fill = body.children.whereType<Fill>().single as Fill;
            // final e = fill.children.first as RadialGradient;
            // // e.children.first as GradientStop
            // print(body);
            // .whereType<Fill>().single;
            // fill.paint.color = Color.fromARGB(255, 255, 0, 255);
          }
          break;
      }
    });
  }
}