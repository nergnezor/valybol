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
    // , shape!.worldTranslation.values[1]);
    // print(ballPos);
    for (var p in s.players) {
      if (!p.isCharging && p.charge > 0) {
        final dCharge = min(10, p.charge);
        p.charge -= dCharge;
        final dTarget = p.targetSpawn - p.target!.worldTranslation;
        ballVelocity.y = min(0, ballVelocity.y);
        ballVelocity.x -= dCharge * cos(dTarget.y / dTarget.x);
        ballVelocity.y -= dCharge * sin(dTarget.y / dTarget.x);
        // p.target.y -= dCharge * dTarget.x / 100;
        // ballVelocity
      }
      p.target!.x = p.target!.x.clamp(s.constraint!.left, s.constraint!.right);
      p.target!.y = p.target!.y.clamp(s.constraint!.top, s.constraint!.bottom);
      Vec2D tailPos = p.tail.worldTranslation;
      if (p.tailPrevious.length() == 0) {
        p.tailPrevious = tailPos;
        continue;
      }

      final d = ballPos - tailPos;
      final dist = sqrt(d.x * d.x + d.y * d.y);
      if (dist > 50 || d.y > 50) {
        continue;
      }
      shape!.x -= d.x;
      final tailMovement = tailPos - p.tailPrevious;

      if (ballPos.y + ballRadius! > tailPos.y) {
        shape!.worldTranslation.y = p.tail.worldTranslation.y - ballRadius!;
        if (ballVelocity.y > 0) {
          ballVelocity.y = 0;
        }
        ballVelocity.y = min(0, ballVelocity.y);
        // ballVelocity += tailMovement * dt * 10;
        ballIsFalling = false;
      }

      p.tailPrevious = tailPos;
    }
    ballVelocity.x *= 0.98;
    if (ballIsFalling) {
      ballVelocity.y += 0.3;
      if (ballPos.y >= s.court!.y) {
        ballVelocity = Vec2D();
        shape!.opacity -= 0.05;
        if (shape!.opacity <= 0) {
          shape!.opacity = 1;
          shape!.x = ballSpawn.x;
          shape!.y = ballSpawn.y;
        }
      }
    }

    shape!.x += ballVelocity.x;
    shape!.y += ballVelocity.y;
  }
}
