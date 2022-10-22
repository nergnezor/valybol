import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:valybol/gamestate.dart';

class Ball {
  Shape? shape;
  Vec2D velocity = Vec2D();
  Vec2D? prev;
  bool isFalling = true; //
  double? radius;
  bool wasFalling = true;

  void update(double dt, Gamestate g) {
    shape!.x += velocity.x * dt;
    shape!.x = shape!.x.clamp(-400, 400);
    velocity.x *= 0.98;
    if (prev == null) {
      prev = shape!.worldTranslation;
      return;
    }

    velocity.y = shape!.worldTranslation.y - prev!.y;
    if (velocity.y == 0) {
      // print('stilla');
    }
    prev = shape!.worldTranslation;
  }
}
