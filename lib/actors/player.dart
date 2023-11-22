import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:fluttery/mmotkim.dart';

enum PlayerState { idle, left, right, up, down }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<Mmotkim>, KeyboardHandler {
  late final SpriteAnimation faceDown;
  late final SpriteAnimation faceUp;
  late final SpriteAnimation faceLeft;
  late final SpriteAnimation faceRight;
  late final SpriteAnimation moveDown;
  late final SpriteAnimation moveUp;
  late final SpriteAnimation moveLeft;
  late final SpriteAnimation moveRight;
  late final String character = 'Character_001.png';
  int horizontalDirection = 0;
  int verticalDirection = 0;
  final double moveSpeed = 100;
  final Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    position += velocity * dt
      ..normalize();
    // position.x += horizontalDirection * moveSpeed * dt;
    // position.y += verticalDirection * moveSpeed * dt;
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    verticalDirection = 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
                keysPressed.contains(LogicalKeyboardKey.keyA))
            ? -1
            : 0;

    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
                keysPressed.contains(LogicalKeyboardKey.keyD))
            ? 1
            : 0;

    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
            keysPressed.contains(LogicalKeyboardKey.keyS))
        ? 1
        : 0;

    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
            keysPressed.contains(LogicalKeyboardKey.keyW))
        ? -1
        : 0;

    return true;
  }

  void _loadAllAnimations() {
    moveDown = _getMoveAnimation(start: 0, end: 3, amount: 4, stepTime: 0.2);
    moveLeft = _getMoveAnimation(start: 4, end: 7, amount: 8, stepTime: 0.2);
    moveRight = _getMoveAnimation(start: 8, end: 11, amount: 12, stepTime: 0.2);
    moveUp = _getMoveAnimation(start: 12, end: 15, amount: 16, stepTime: 0.2);

    final spriteSheet = SpriteSheet(
        image: gameRef.images.fromCache(character), srcSize: Vector2.all(72));
    var down = spriteSheet.createAnimation(row: 0, stepTime: 0.2);

    animations = {PlayerState.down: moveDown};

    current = PlayerState.down;
  }

  SpriteAnimation _getMoveAnimation({
    required int start,
    required int end,
    required int amount,
    required double stepTime,
  }) {
    final List<double> stepTimes = [];
    for (int i = 0; i < amount; i++) {
      stepTimes.add(stepTime);
    }
    return SpriteAnimation.fromFrameData(
      gameRef.images.fromCache(character),
      SpriteAnimationData.range(
        start: start,
        end: end,
        amount: amount,
        stepTimes: stepTimes,
        textureSize: Vector2.all(72),
      ),
    );
  }
}
