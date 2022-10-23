import 'package:rive/math.dart';
import 'package:valybol/opponent.dart';
import 'ball.dart';
import 'player.dart';
// import 'rivegame.dart';

class Gamestate {
  // List<Player> players = <Player>[];
  Ball ball = Ball();
  late Player p;
  Vec2D? court;
  double scale = 0;
  // late CustomRiveComponent component;
  Opponent? opponent;
}
