import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CollisionBlock extends PositionComponent with CollisionCallbacks {
  late ShapeHitbox hitbox;
  final _defaultColor = Colors.cyan;
  final _collisionStartColor = Colors.amber;
  bool _collision = false;

  CollisionBlock({
    Vector2? position,
    Vector2? size,
  }) : super(
          position: position,
          size: size,
          priority: 3,
        ) {
    debugMode = false;
  }

  @override
  FutureOr<void> onLoad() {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true
      ..collisionType = CollisionType.active;
    add(hitbox);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isColliding) {
      hitbox.paint.color = _collisionStartColor;
    } else {
      hitbox.paint.color = _defaultColor;
    }
    // print(hitbox.isColliding);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    hitbox.paint.color = _collisionStartColor;
    _collision = true;
    super.onCollision(intersectionPoints, other);
  }
}
