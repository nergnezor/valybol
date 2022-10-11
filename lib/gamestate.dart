import 'dart:ui';
import 'package:rive/math.dart';
import 'ball.dart';
import 'player.dart';

class Gamestate {
  List<Player> players = <Player>[];
  Ball ball = Ball();
  Player? player;
  Rect? constraint;
  Vec2D? court;
  bool riveLoaded = false;
}
