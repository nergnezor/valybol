import 'dart:math';

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
    // final offset = g.players.first.component.absoluteTopLeftPosition;
    // bottom = shape!.worldTranslation + Vec2D.fromValues(0, radius!);
    int c = 0;
    if (isFalling) {
      moveOpponent(g.players[1]);
      velocity.y -= 1000 * dt;
      if (shape!.worldTranslation.y > g.court!.y) {
        velocity = Vec2D();
        g.ball.shape!.opacity -= 0.05;
        if (g.ball.shape!.opacity <= 0) {
          g.ball.shape!.opacity = 1;
          g.ball.shape!.translation = g.ball.spawn;
        }
      }
    }
    for (var p in g.players) {
      moveTail(p, dt);
      final ballOffset = getBallOffset(p);
      // print(dBallTail);
      if (ballOffset.y > 0 &&
          ballOffset.y < radius! &&
          ballOffset.x.abs() < radius! * 3) {
        // print(p.component.position);
        isFalling = false;
        shape!.y -= ballOffset.y;
        if (ballOffset.x.abs() > 1) shape!.x -= (ballOffset.x / 4);

        velocity.x = 70 * p.speed.x;
        velocity.y = 70 * p.speed.y;
      }
      p.rootBone?.x = p.rootBone!.x.clamp(p.clampStart, p.clampEnd);
    }
    wasFalling = isFalling;
    shape!.x += velocity.x * dt;
    shape!.y -= velocity.y * dt;
  }

  getBallOffset(Player p) {
    final playerOffset = p.component.position;
    Vec2D tailPos = p.tail!.worldTranslation +
        Vec2D.fromValues(playerOffset.x, playerOffset.y) -
        p.offset;
    if (tailPos == Vec2D()) return 0;
    if (p.component.isFlippedHorizontally) {
      tailPos.x = playerOffset.x - p.offset.x - p.tail!.worldTranslation.x;
    }
    var dBallTail = shape!.worldTranslation - tailPos;
    dBallTail.y += radius!;
    return dBallTail;
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

  void moveOpponent(Player player) {
    if (velocity.y > 0) return;
    final ballOffset = getBallOffset(player);
    // print(player.rootBone?.x);
    player.rootBone?.x +=
        min(5, ballOffset.x.abs() as double) * (ballOffset.x < 0 ? 1 : -1);
  }
}
