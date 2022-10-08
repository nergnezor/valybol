import 'package:rive/components.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';

class Player {
  late Shape target;
  late Node tail;
  Vec2D tailPrevious = Vec2D();
  int charge = 0;
  bool isCharging = false;
  double angle = 0;
  Vec2D targetSpawn = Vec2D();
  Vec2D ballSpawn = Vec2D();
}
