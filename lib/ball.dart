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
    // ballIsFalling = true;
    for (var p in s.players) {
      ++count;
      if (p.charge > 0 && !p.isCharging) {
        p.speed.y += 200 * dt;
        // p.speed.y = max(p.speed.y, 1000 * dt);
        final dy = min(p.speed.y, p.charge);
        p.target?.y -= dy;
        p.charge -= dy;
        if (p.charge <= 0) {
          p.speed = Vec2D();
        }
      }
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
        ballVelocity.x *= 0.98;
        shape!.x -= 5 * d.x * dt;
        // }
        var tailSpeed = dTail;
        tailSpeed.x *= dt;
        tailSpeed.y *= 0.8 / dt;

        if (tailSpeed.y <= ballVelocity.y) {
          shape!.y -= d.y / 2;
          ballVelocity.y = tailSpeed.y;
          // ballIsFalling = false;
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
