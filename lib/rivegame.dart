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

class CustomRiveComponent extends RiveComponent with Tappable, Draggable {
  @override
  final Artboard artboard;
  final Gamestate gamestate;

  CustomRiveComponent(this.artboard, this.gamestate)
      : super(
            artboard: artboard, size: Vector2(artboard.width, artboard.height));
  // late OneShotAnimation controller;
  late StateMachineController controller;
  late Fill fill;

  @override
  Future<void>? onLoad() {
    // StateMachine? stateMachine = artboard.defaultStateMachine;
    // stateMachine.
    // stateMachine = StateMachine();
    // stateMachine =artboard.defaultStateMachine
    controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
    // controller = OneShotAnimation('shoot', autoplay: true);
    artboard.addController(controller);
    // controller.artboard.addController(controller);
    // artboard.forEachComponent((child) {
    //   if (child.name == 'fyllning') {
    //     fill = child as Fill;
    //   }
    // });
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
            components.last.position.x += gamestate.court!.x / 2;


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
          // (child as Shape).opacity = 0;
          s.player?.target = child;
          s.player?.targetSpawn = child.worldTranslation;
          if (s.constraint == null) {
            final c = child.children.whereType<TranslationConstraint>().single;
            s.constraint =
                Rect.fromLTRB(c.minValue, c.minValueY, c.maxValue, c.maxValueY);
            return;
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

          s.ball.ballSpawn.x = child.x + 50;
          s.ball.ballSpawn.y = child.y;
          break;
        case 'ball ellipse':
          s.ball.ballRadius = (child as Ellipse).radiusX;
          break;
        case 'val':
          var c = child as RootBone;
          if (s.players.length.isEven) {
            c.scaleY *= -1;
          }    
          break;
      }
    });
  }
}
