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
    Vec2D ballPos = shape!.worldTranslation;
    var count = 0;
    ballIsFalling = true;
    for (var p in s.players) {
      ++count;
      Vec2D tailPos = p.tail.worldTranslation;
      if (count == 2) {
        tailPos.x += 300;
      }
      final dTail = tailPos - p.tailPrevious;
      p.tailPrevious = tailPos;
      final d =
          ballPos + Vec2D.fromValues(ballRadius! / 2, ballRadius!) - tailPos;
      final dist = sqrt(d.x * d.x + d.y * d.y);
      if (d.y >= 0 && dist < ballRadius! * 2) {
        // if (d.y > 0) {
        shape!.x -= 5 * d.x * dt;
        // }
        var tailSpeed = dTail;
        tailSpeed.x *= dt;
        tailSpeed.y *= 0.8 / dt;

        shape!.y -= d.y;
        if (tailSpeed.y <= ballVelocity.y) {
          ballVelocity.y = tailSpeed.y;
          ballVelocity.x = 0;
          ballIsFalling = false;
        } else {
          double dir = ballPos.x < s.court!.x / 2 ? 1 : -1;
          ballVelocity.x = 180 * dir;
          print('falling');
        }
      }
    }
    if (ballIsFalling) {
      ballVelocity.y += 1000 * dt;
      if (ballPos.y > s.court!.y) {
        ballVelocity = Vec2D();
        s.ball.shape!.opacity -= 0.01;
        if (s.ball.shape!.opacity <= 0) {
          s.ball.shape!.opacity = 1;
          s.ball.shape!.translation = s.ball.ballSpawn;
        }
      }
    }
    shape!.x += ballVelocity.x * dt;
    shape!.y += ballVelocity.y * dt;
  }
}
