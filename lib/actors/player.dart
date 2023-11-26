// ignore_for_file: unused_import

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
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
  final double moveSpeed = 300;
  final Vector2 velocity = Vector2.zero();
  static const double acceleration = 0.2;
  var state = PlayerState.down;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateMovement(dt);
    _updateDisplay();
    super.update(dt);
  }

  void _updateMovement(double dt) {
    Vector2 v =
        Vector2(horizontalDirection.toDouble(), verticalDirection.toDouble());
    v.clampLength(-1, 1);

    position += v * moveSpeed * dt;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    verticalDirection = 0;
    bool keyLeft = (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA));
    bool keyDown = (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS));
    bool keyRight = (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD));
    bool keyUp = (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW));

    if (keyLeft) state = PlayerState.left;
    else if (keyRight) state = PlayerState.right;
    else if (keyDown) state = PlayerState.down;
    else if (keyUp) state = PlayerState.up;

    horizontalDirection += keyLeft ? -1 : 0;
    horizontalDirection += keyRight ? 1 : 0;
    verticalDirection += keyDown ? 1 : 0;
    verticalDirection += keyUp ? -1 : 0;

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

    animations = {
      PlayerState.down: moveDown,
      PlayerState.left: moveLeft,
      PlayerState.right: moveRight,
      PlayerState.up: moveUp,
    };
  }

  void _updateDisplay() {
    current = state;
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
