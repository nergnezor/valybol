import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/gamestate.dart';
import 'package:valybol/player.dart';

class Ball {
  Shape? shape;
  Vec2D velocity = Vec2D();
  Vec2D spawn = Vec2D();
  bool isFalling = true; //
  double? radius;
  bool wasFalling = true;
  bool wasCharging = false;
  // Vec2D bottom = Vec2D();

  void update(double dt, Gamestate g) {
    isFalling = true;
    final offset = g.players.first.component.absoluteTopLeftPosition;
    // bottom = shape!.worldTranslation + Vec2D.fromValues(0, radius!);
    int c = 0;
    for (var p in g.players) {
      moveTail(p, dt);
      final playerOffset = p.component.position;
      Vec2D tailPos = p.tail!.worldTranslation +
          Vec2D.fromValues(playerOffset.x, playerOffset.y) -
          p.offset;
      if (tailPos == Vec2D()) continue;
      if (p.component.isFlippedHorizontally) {
        tailPos.x = playerOffset.x - p.offset.x - p.tail!.worldTranslation.x;
      }
      var dBallTail = shape!.worldTranslation - tailPos;
      dBallTail.y += radius!;
      if (++c == 2) {
        print(dBallTail);
      }
      if (dBallTail.y > 0 &&
          dBallTail.y < radius! &&
          dBallTail.x.abs() < radius! * 3) {
        // print(p.component.position);
        isFalling = false;
        shape!.y -= dBallTail.y;
        if (dBallTail.x.abs() > 1) shape!.x -= (dBallTail.x / 4);

        velocity.x = 70 * p.speed.x;
        velocity.y = 70 * p.speed.y;
      }
    }
    if (isFalling) {
      velocity.y -= 1000 * dt;
      if (shape!.worldTranslation.y > g.court!.y + offset.y) {
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
    shape!.y -= velocity.y * dt;
  }

  void moveTail(Player p, double dt) {
    final dTarget = p.target!.translation - p.targetSpawn;
    if (dTarget.x < 0 && !p.isCharging) {
      p.speed.y += 100 * dt;
      p.speed.x =
          p.xFactor * p.speed.y * (p.component.isFlippedHorizontally ? -1 : 1);
      p.target?.y += p.speed.x * (p.component.isFlippedHorizontally ? -1 : 1);
      p.target?.x += p.speed.y;
    } else {
      p.speed = Vec2D();
    }
  }
}
