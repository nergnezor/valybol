// import 'dart:math';

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
  // Vec2D bottom = Vec2D();

  void update(double dt, Gamestate g) {
    if (g.player.isCharging) {
      return;
    }
    // isFalling = true;
    // // final offset = g.players.first.component.absoluteTopLeftPosition;
    // // bottom = shape!.worldTranslation + Vec2D.fromValues(0, radius!);
    // int c = 0;
    // // if (!g.players[0].isCharging) moveOpponent(g.players[1]);
    // for (var p in g.players) {
    // final ballOffset = getBallOffset(g.player);
    //   moveTail(p, dt);
    //   // print(dBallTail);
    //   if (ballOffset.y > 0 &&
    //       ballOffset.y < radius! &&
    //       ballOffset.x.abs() < radius! * 3) {
    //     // print(p.component.position);
    //     isFalling = false;
    //     shape!.y -= ballOffset.y;
    //     if (ballOffset.x.abs() > 1) shape!.x -= (ballOffset.x / 4);

    //     velocity.x = 70 * p.speed.x;
    //     velocity.y = 70 * p.speed.y;
    //   }
    //   p.rootBone?.x = p.rootBone!.x.clamp(p.clampStart, p.clampEnd);
    // }
    // if (isFalling) {
    //   velocity.y -= 1000 * dt;
    //   // if (shape!.worldTranslation.y > 50) {
    //   //   velocity = Vec2D();
    //   //   g.ball.shape!.opacity -= 0.05;
    //   //   if (g.ball.shape!.opacity <= 0) {
    //   //     g.ball.shape!.opacity = 1;
    //   //     g.ball.shape!.translation = g.ball.spawn;
    //   //   }
    //   // }
    // }
    // wasFalling = isFalling;
    shape!.x += velocity.x * dt;
    shape!.x = shape!.x.clamp(-100, 100);

    // shape!.y -= velocity.y * dt;
  }

  // getBallOffset(Player p) {
  //   final playerOffset = p.component.position;
  //   Vec2D tailPos = p.tail!.worldTranslation +
  //       Vec2D.fromValues(playerOffset.x, playerOffset.y) -
  //       p.offset;
  //   if (tailPos == Vec2D()) return Vec2D.fromValues(1000, 1000);
  //   if (p.component.isFlippedHorizontally) {
  //     tailPos.x = playerOffset.x - p.offset.x - p.tail!.worldTranslation.x;
  //   }
  //   Vec2D dBallTail = shape!.worldTranslation - tailPos;
  //   dBallTail.y += radius!;
  //   return dBallTail;
  // }

  // void moveTail(Player p, double dt) {
  //   final dTarget = p.target!.translation - p.targetSpawn;
  //   if (dTarget.x < 0 && !p.isCharging) {
  //     p.speed.y += 100 * dt;
  //     p.speed.x =
  //         p.xFactor * p.speed.y * (p.component.isFlippedHorizontally ? -1 : 1);
  //     p.target?.y += p.speed.x * (p.component.isFlippedHorizontally ? -1 : 1);
  //     p.target?.x += p.speed.y;
  //   } else {
  //     p.speed = Vec2D();
  //     // print(p.speed);
  //     // if (p.shooting) {
  //     //   p.shooting = false;
  //     // }
  //   }
  // }

  // void moveOpponent(Player p) {
  //   // print(p.target!.y);
  //   // if (velocity.y > -50) {
  //   //   // p.target!.y -= 10;
  //   //   p.target?.y = p.target!.y.clamp(p.constraint!.top, p.constraint!.bottom);
  //   //   return;
  //   // }
  //   final Vec2D ballOffset = getBallOffset(p);

  //   // print(player.rootBone?.x);
  //   p.rootBone?.x += min(5, ballOffset.x.abs()) * (ballOffset.x < 0 ? 1 : -1);
  //   final distance = sqrt(pow(ballOffset.x, 2) + pow(ballOffset.y, 2));
  //   // final d = p.target!.translation - p.targetSpawn;
  //   // print(ballOffset);
  //   // if (!p.isCharging) {
  //   //   p.target!.y -= 2;
  //   if (p.isCharging) {
  //     // if (p.target!.y >= p.constraint!.right) {
  //     //   p.shooting = false;
  //     // }
  //     if (distance < 5) {
  //       p.isCharging = false;
  //       p.shooting = true;
  //       p.component.controller.inputs.first.change(true);

  //       velocity = Vec2D();
  //     }
  //     return;
  //   }
  //   //   // p.target!.x -= p.target!.translation.x.compareTo(p.targetSpawn.x);
  //   //   // p.target?.x = p.target!.x.clamp(p.constraint!.left, p.constraint!.right);
  //   //   p.target?.y = p.target!.y.clamp(p.constraint!.top, p.constraint!.bottom);
  //   // }
  //   if (distance < 200 && !p.shooting) {
  //     p.component.controller.inputs.first.change(true);
  //     p.isCharging = true;
  //     // if (distance > 1) {
  //     //   p.target!.x += d.x < 0 ? 1 : -1;
  //     //   p.target!.y += d.y < 0 ? 1 : -1;
  //     // }

  //     // return;
  //   }

  //   // p.target!.x -= 2;
  //   // // p.target!.y += 4;
  //   // // p.target?.x = p.target!.x.clamp(p.constraint!.left, p.constraint!.right);
  //   // p.isCharging = true;
  //   // // print(distance);
  //   // // print(isFalling);
  //   // // final dTarget = p.target!.translation - p.targetSpawn;
  //   // // print(dTarget);

  //   // if (d.y > p.constraint!.bottom && !p.shooting) {
  //   //   p.shooting = true;
  //   //   // p.target?.y = p.constraint!.right;
  //   //   // if (distance < 1 && velocity.y < 0) {
  //   //   p.isCharging = false;
  //   //   if (!d.x.isNaN) p.xFactor = -1 * d.y / d.x;
  //   //   // p.xFactor = 0.5;
  //   //   p.speed.y = 0;
  //   // }
  //   // // p.target?.y = p.target!.y.clamp(p.constraint!.top, p.constraint!.bottom);

  //   // p.wasCharging = p.isCharging;
  // }
}
