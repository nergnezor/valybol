import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

void main() {
  runApp(GameWidget(
    game: MyGame(),
  ));
}

class MyGame extends FlameGame with HasTappables, HasDraggables {
  @override
  Color backgroundColor() => const Color(0xff171717);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    for (double xPosition = 0; xPosition < 800; xPosition += 200) {
      for (double yPosition = 0; yPosition < 800; yPosition += 200) {
        await createBubble(xPosition, yPosition);
      }
    }
  }

  Future<void> createBubble(double xPosition, double yPosition) async {
    Artboard artboard =
        await loadArtboard(RiveFile.asset('assets/bubble_still.riv'));
    BubbleComponent component = BubbleComponent(artboard: artboard);
    component.position = Vector2(xPosition, yPosition) - component.size / 2;
    add(component);
  }

  @override
  void onTapUp(int i, TapUpInfo info) {
    super.onTapUp(i, info);
    print('handled 2?' + info.handled.toString());
    if (info.handled) {
      return;
    }
    createBubble(info.eventPosition.game.x, info.eventPosition.game.y);
  }
}

class BubbleComponent extends RiveComponent
    with HasGameRef, Tappable, Draggable {
  final Artboard artboard;
  BubbleComponent({required this.artboard})
      : super(artboard: artboard, size: Vector2.all(200));

  late OneShotAnimation controller;
  late Fill fill;
  Vector2 velocity = Vector2.zero();

  @override
  Future<void>? onLoad() {
    controller = OneShotAnimation('Idle', autoplay: false);
    artboard.addController(controller);
    artboard.forEachComponent((child) {
      if (child.name == 'fyllning') {
        fill = child as Fill;
      }
    });
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity! * dt * 1000;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    // print('handled?' + info.handled.toString());

    // var er = artboard.children.first;
    // .firstWhere(
    //     (fill) => fill.name == 'fyllning');
    info.handled = true;
    // var eri;
    // for (var child in artboard.children) {
    //   if (child.name == 'fyllning') {
    //     eri = child;
    //   }
    // }

    if (!controller.isActive) {
      fill.paint.color = Colors.red.withOpacity(0.25);
      controller.isActive = true;
      // print('tapped  and hopefully, it is moving');
    } else {
      gameRef.remove(this);
    }
    return true;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    position = info.eventPosition.game - size / 2;
// move draggaable to the top
    // gameRef.setDraggable(this, true);
    velocity = (info.delta.game / 60);

    return true;
  }
}
