import 'dart:math';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/gamestate.dart';

class Ball {
  Shape? shape;
  Vec2D velocity = Vec2D();
  Vec2D spawn = Vec2D();
  bool isFalling = true; //
  double? radius;

  bool wasFalling = true;
  bool wasCharging = false;

  void update(double dt, Gamestate g) {
    if (shape == null) {
      return;
    }
    isFalling = true; //
    final offset = g.players.first.component.absoluteTopLeftPosition;
    Vec2D ballPos = shape!.worldTranslation +
        Vec2D.fromValues(offset.x, offset.y) +
        Vec2D.fromValues(0, radius!);
    for (var p in g.players) {
      final dTarget = p.target!.translation - p.targetSpawn;
      if (dTarget.x < 0 && !p.isCharging) {
        p.speed.y += 100 * dt;
        p.speed.x = p.xFactor * p.speed.y;
        p.target?.y += p.speed.x;
        p.target?.x += p.speed.y;
        print(p.speed);
        // p.target?.y =
        //     p.target!.y.clamp(p.constraint!.top, p.constraint!.bottom);
        // p.target?.x =
        //     p.target!.x.clamp(p.constraint!.left, p.constraint!.right);
      }
      final playerOffset = p.component.absoluteTopLeftPosition;

      // if (p.invertX) {
      //   playerOffset.x -= 2 * p.rootBone!.x;
      //   // tailPos.x -= dTarget.x;
      // }
      Vec2D tailPos = p.tail!.worldTranslation +
          Vec2D.fromValues(playerOffset.x, playerOffset.y);
      if (tailPos == Vec2D()) continue;
      final dTail = tailPos - p.tailPrevious;
      p.tailPrevious = tailPos;
      var dBallTail = ballPos - tailPos;
      if (p.invertX) {
        // dBallTail.x *= -1;
      }
      if (dBallTail.y > -1 && dBallTail.x.abs() < radius! * 2) {
        isFalling = false;
        shape!.y -= dBallTail.y;
        if (wasFalling) {
          velocity = Vec2D();
        }
        if (dBallTail.x.abs() > 1) {
          shape!.x -= (dBallTail.x / 2); // * (p.invertX ? -1 : 1);
        }
        var tailSpeed = dTail;
        tailSpeed.x *= dt;
        tailSpeed.y *= 5000 * dt;

        if (tailSpeed.y <= velocity.y) {
          velocity.y = max(tailSpeed.y, -1000);
          velocity.x = -tailSpeed.y * p.xFactor / 5;
        }
      }
    }
    if (isFalling) {
      velocity.y += 1000 * dt;
      if (ballPos.y > g.court!.y + offset.y) {
        velocity = Vec2D();
        g.ball.shape!.opacity -= 0.05;
        if (g.ball.shape!.opacity <= 0) {
          g.ball.shape!.opacity = 1;
          g.ball.shape!.translation = g.ball.spawn;
        }
      }
    }
    wasFalling = isFalling;
    shape!.x += velocity.x * dt;
    shape!.y += velocity.y * dt;
  }
}
