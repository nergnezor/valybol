import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';


void main() {
runApp(GameWidget(
game: MyGame(),
));
if (!kIsWeb && Platform.isAndroid) {
try {
FlutterDisplayMode.setHighRefreshRate();
} catch (e) {
print(e);
}
}
}

class MyGame extends FlameGame with HasTappables, HasDraggables {
static double frameRate = 60;

@override
Color backgroundColor() => const Color(0xff171717);

@override
Future<void> onLoad() async {
BubbleComponent.screenSize = size;
await super.onLoad();
createBubble(200,200);
}

Future<void> createBubble(double xPosition, double yPosition) async {
Artboard artboard =
await loadArtboard(RiveFile.asset('assets/bubble_still.riv'));
BubbleComponent component = BubbleComponent(artboard: artboard);
component.position = Vector2(xPosition, yPosition) - component.size / 2;
add(component);
}

@override
void onTapDown(int i, TapDownInfo info) {
super.onTapDown(i, info);
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
: super(
artboard: artboard,
size: Vector2.all(4));

late OneShotAnimation controller;
late Fill fill;
Vector2 velocity = Vector2.zero();
static late Vector2 screenSize;
double lifeTime = 0;
double maxVelocity = 0;
bool growing=true;

@override
Future<void>? onLoad() {
controller = OneShotAnimation('Idle', autoplay: true);
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
edgeBounce();
lifeTime += dt;
float(dt);
super.update(dt);
position += velocity * dt * 10000;
velocity *= 0.99;
if (velocity == Vector2.zero() && growing){
size.x +=1;
size.y +=1;
}
position.y += dt * 10;
}

void edgeBounce() {
//  bounce
if (position.x < 0 || position.x > screenSize.x - size.x) {
velocity.x = -velocity.x;
scale.x -= velocity.x.abs() * 2;
}
if (position.y < 0 || position.y > screenSize.y - size.y) {
velocity.y = -velocity.y;
scale.y -= velocity.y.abs() * 2;
}
position.clamp(Vector2.zero(), screenSize - size);
scale.x += (1 - scale.x) * 0.1;
scale.y += (1 - scale.y) * 0.1;
scale.clamp(Vector2.all(0.5), Vector2.all(1));
}

@override
bool onTapDown(TapDownInfo info) {
info.handled = true;
gameRef.remove(this);
return true;
}

@override
bool onTapUp(TapUpInfo info) {
growing=false;
return true;
}

@override
bool onDragUpdate(DragUpdateInfo info) {
position = info.eventPosition.game - size / 2;
velocity = (info.delta.game / 60);

return true;
}

void float(double dt) {
position += Vector2.all(sin(lifeTime * 3) * dt * 10);
}
}