import 'dart:ui';

import 'package:rive/components.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/rivegame.dart';
import 'package:rive/src/rive_core/bones/root_bone.dart';

class Player {
  Node? target;
  Node? tail;
  bool isCharging = false;
  double xFactor = 0;
  Vec2D targetSpawn = Vec2D();
  Vec2D ballSpawn = Vec2D();
  Vec2D speed = Vec2D();
  late CustomRiveComponent component;
  RootBone? rootBone;
  Rect? constraint;
  Fill? fill;
  Vec2D offset = Vec2D();
  double clampStart = 0;
  double clampEnd = 0;
}
