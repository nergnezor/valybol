import 'package:rive/components.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/rivegame.dart';

class Player {
  Shape? target;
  late Node tail;
  Vec2D tailPrevious = Vec2D();
  double charge = 0;
  bool isCharging = false;
  double angle = 0;
  Vec2D targetSpawn = Vec2D();
  Vec2D ballSpawn = Vec2D();
  Vec2D speed = Vec2D();
  late CustomRiveComponent component;
}
