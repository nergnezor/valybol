import 'package:rive/components.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/rivegame.dart';
import 'package:rive/src/rive_core/bones/root_bone.dart';

class Player {
  Shape? target;
  Node? tail;
  Vec2D tailPrevious = Vec2D();
  double charge = 0;
  bool isCharging = false;
  double xFactor = 0;
  Vec2D targetSpawn = Vec2D();
  Vec2D ballSpawn = Vec2D();
  Vec2D speed = Vec2D();
  late CustomRiveComponent component;
  RootBone? rootBone;
}
