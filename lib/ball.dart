import 'dart:math';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/gamestate.dart';

class Ball {
  Shape? shape;
  Vec2D ballVelocity = Vec2D();
  Vec2D ballSpawn = Vec2D();
  bool ballIsFalling = true; //
  double? ballRadius;

  void update(double dt, Gamestate s) {
    if (shape == null) {
      return;
    }
    ballIsFalling = true;
    Vec2D ballPos = shape!.worldTranslation;
    var count = 0;
    for (var p in s.players) {
      ++count;
      Vec2D tailPos = p.tail.worldTranslation;
      if (count == 2) {
        tailPos.x += 300;
      }
      final d = ballPos - tailPos;
      final dist = sqrt(d.x * d.x + d.y * d.y);
      if (ballPos.y + ballRadius! > tailPos.y && d.x.abs() < ballRadius!) {
        ballIsFalling = false;
        if (ballVelocity.y > 0) {
          ballVelocity.y = 0;
        }
        final yDiff = tailPos.y - (ballPos.y + ballRadius!);
        shape!.y += yDiff;
        if (yDiff / dt < ballVelocity.y) {
          ballVelocity.y = 0.002 * yDiff / dt;
        }
      }
    }
    if (ballIsFalling) {
      ballVelocity.y += 15 * dt;
      if (ballPos.y > s.court!.y) {
        ballVelocity = Vec2D();
        s.ball.shape!.opacity -= 0.01;
        if (s.ball.shape!.opacity <= 0) {
          s.ball.shape!.opacity = 1;
          s.ball.shape!.translation = s.ball.ballSpawn;
        }
      }
    }
    shape!.x += ballVelocity.x;
    shape!.y += ballVelocity.y;
  }
}
