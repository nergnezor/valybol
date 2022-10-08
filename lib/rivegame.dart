import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
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

class CustomRiveComponent extends RiveComponent
    with HasGameRef, Tappable, Draggable {
  @override
  final Artboard artboard;
  final Gamestate gamestate;

  CustomRiveComponent(this.artboard, this.gamestate)
      : super(
            artboard: artboard, size: Vector2(artboard.width, artboard.height));
  late OneShotAnimation controller;
  late Fill fill;

  @override
  Future<void>? onLoad() {
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
  c = await addRiveArtboard('assets/whale.riv', size, gamestate);
  components.add(c);
  c = await addRiveArtboard('assets/whale.riv', size, gamestate);
  components.add(c);

  return components;
}

void parseArtboard(Artboard a, Gamestate s) {
  {
    a.forEachComponent((child) {
      switch (child.name) {
        case 'target':
          (child as Shape).opacity = 0;
          s.players.last.target = child as Shape;
          if (s.constraint == null) {
            final c = child.children.whereType<TranslationConstraint>().single;
            s.constraint =
                Rect.fromLTRB(c.minValue, c.minValueY, c.maxValue, c.maxValueY);
            return;
          }
          break;
        case 'rectangle':
          s.court = Vec2D();
          s.court!.x = (child as Rectangle).width;
          s.court!.y = (child as Rectangle).height;
          break;
        case 'tail':
          s.players.last.tail = child as Node;
          break;
        case 'ball':
          s.ball.shape = child as Shape;

          s.ball.ballSpawn.x = child.x + 50;
          s.ball.ballSpawn.y = child.y;
          break;
        case 'ball ellipse':
          s.ball.ballRadius = (child as Ellipse).radiusX;
          break;
        case 'val':
          var c = child as RootBone;
          if (s.players.length.isOdd) {
            c.x += s.court!.x / 2;
            c.scaleY *= -1;
          }
          s.players.add(Player());
          break;
      }
    });
  }
}
