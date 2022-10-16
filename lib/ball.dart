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

  void update(double dt, Gamestate g) {
    if (shape == null) {
      return;
    }
    ballIsFalling = true; //
    Vec2D ballPos = shape!.worldTranslation;
    for (var p in g.players) {
      final dTarget = p.target!.translation - p.targetSpawn;
      // if (dTarget.y > 0 && !p.isCharging) {
      //   p.speed.y -= 100 * dt;
      //   p.speed.x = -p.speed.y * p.xFactor;
      //   p.target?.y += p.speed.y;
      //   p.target?.x += p.speed.x;
      //   p.target?.y =
      //       p.target!.y.clamp(g.constraint!.top, g.constraint!.bottom);
      //   p.target?.x =
      //       p.target!.x.clamp(g.constraint!.left, g.constraint!.right);
      // }
      Vec2D tailPos = p.tail!.worldTranslation;
      if (tailPos == Vec2D()) continue;
      final dTail = tailPos - p.tailPrevious;
      p.tailPrevious = tailPos;
      final d = ballPos + Vec2D.fromValues(ballRadius!, ballRadius!) - tailPos;
      // final dist = sqrt(d.x * d.x + d.y * d.y);
      if (d.y > 0 && d.x.abs() < ballRadius! * 2) {
        shape!.y -= d.y;
        // if (ballIsFalling) {
        //   ballVelocity = Vec2D();
        // ballIsFalling = false;
        // }
        // if (d.y > 0) {
        //   ballVelocity.x *= 0.98;
        //   if (d.x.abs() > 5) shape!.x -= 50 * d.x * dt;
        //   // }
        var tailSpeed = dTail;
        tailSpeed.x *= dt;
        tailSpeed.y *= 0.8 / dt;

        if (tailSpeed.y <= ballVelocity.y) {
          ballIsFalling = false;
          ballVelocity.y = tailSpeed.y;
        }
      }
    }
    if (ballIsFalling) {
      ballVelocity.y += 1000 * dt;
      if (ballPos.y > g.court!.y) {
        ballVelocity = Vec2D();
        g.ball.shape!.opacity -= 0.01;
        if (g.ball.shape!.opacity <= 0) {
          g.ball.shape!.opacity = 1;
          g.ball.shape!.translation = g.ball.ballSpawn;
        }
      }
    }
    shape!.x += ballVelocity.x * dt;
    shape!.y += ballVelocity.y * dt;
  }
}
