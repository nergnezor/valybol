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
}

Future<void> createBubble(double xPosition, double yPosition) async {
Artboard artboard =
await loadArtboard(RiveFile.asset('assets/bubble_still.riv'));
BubbleComponent component = BubbleComponent(artboard: artboard);
component.position = Vector2(xPosition, yPosition) - component.size / 2;
add(component);
}

@override
void onDragStart(int i, DragStartInfo info) {
super.onDragStart(i, info);
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
size: Vector2.all(20));

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
if (lifeTime>10.0){
gameRef.remove(this);
}
float(dt);
super.update(dt);
position += velocity * dt * 10000;
velocity *= 0.99;
position.y += dt * 10;
if (growing)
{
size.x +=2;
size.y +=2;
position.x-=1;
position.y-=1;
if (size.x>400){
gameRef.remove(this);
}}
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
bool onDragEnd(DragEndInfo info){
growing=false;
return false;
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