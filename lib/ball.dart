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

  void update(double dt, Gamestate g) {
    if (shape == null) {
      return;
    }
    isFalling = true; //
    final offset = g.players.first.component.absoluteTopLeftPosition;
    Vec2D ballPos =
        shape!.worldTranslation + Vec2D.fromValues(offset.x, offset.y);
    for (var p in g.players) {
      final dTarget = p.target!.translation - p.targetSpawn;
      if (dTarget.y > 0 && !p.isCharging) {
        p.speed.y -= 200 * dt;
        p.speed.x = -p.speed.y * p.xFactor;
        p.target?.y += p.speed.y;
        p.target?.x += p.speed.x;
        p.target?.y =
            p.target!.y.clamp(g.constraint!.top, g.constraint!.bottom);
        p.target?.x =
            p.target!.x.clamp(g.constraint!.left, g.constraint!.right);
      }
      final playerOffset = p.component.absoluteTopLeftPosition;
      Vec2D tailPos = p.tail!.worldTranslation +
          Vec2D.fromValues(playerOffset.x, playerOffset.y);
      if (tailPos == Vec2D()) continue;
      final dTail = tailPos - p.tailPrevious;
      p.tailPrevious = tailPos;
      final d = ballPos + Vec2D.fromValues(radius!, radius!) - tailPos;
      if (d.y > -1 && d.x.abs() < radius! * 2) {
        isFalling = false;
        shape!.y -= d.y;
        if (wasFalling) {
          velocity = Vec2D();
        }
        if (d.x.abs() > 1) shape!.x -= d.x / 2;
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
        g.ball.shape!.opacity -= 0.01;
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
