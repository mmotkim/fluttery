// ignore_for_file: unused_import

import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
  late SpriteAnimationComponent currentAnimation;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  bool isMoving = false;
  final double moveSpeed = 300;
  final Vector2 velocity = Vector2.zero();
  static const double acceleration = 0.2;
  var playerState = PlayerState.down;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    currentAnimation.render(canvas);
    super.render(canvas);
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

    isMoving = true;

    if (keyLeft)
      playerState = PlayerState.left;
    else if (keyRight)
      playerState = PlayerState.right;
    else if (keyDown)
      playerState = PlayerState.down;
    else if (keyUp)
      playerState = PlayerState.up;
    else
      isMoving = false;

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
    faceDown = _getMoveAnimation(
        start: 0, end: 0, amount: 1, stepTime: 0.2, amountPerRow: 1);

    final spriteSheet = SpriteSheet(
        image: gameRef.images.fromCache(character), srcSize: Vector2.all(72));
    // faceDown = spriteSheet.createAnimation(row: 1, stepTime: 0.2);
    // faceDown = spriteSheet.createAnimationWithVariableStepTimes(row: row, stepTimes: stepTimes)
    currentAnimation = SpriteAnimationComponent();

    // animations = {
    //   PlayerState.down: moveDown,
    //   PlayerState.left: moveLeft,
    //   PlayerState.right: moveRight,
    //   PlayerState.up: moveUp,
    // };
  }

  void _updateDisplay() {
    // if (playerState == PlayerState.idle) {
    //   current = faceDown;
    // }
    // current = playerState;
    switch (playerState) {
      case PlayerState.down:
        if (isMoving) {
          currentAnimation.animation = moveDown;
          print('moveDown');
        } else {
          currentAnimation.animation = faceDown;
          print('faceDOwn');
        }

        break;
      case PlayerState.left:
        currentAnimation.animation = moveLeft;
        break;
      case PlayerState.right:
        currentAnimation.animation = moveRight;
        break;
      case PlayerState.up:
        currentAnimation.animation = moveUp;
        break;
      case PlayerState.idle:
        // TODO: Handle this case.
        break;
    }

    current = currentAnimation.animation;
  }

  SpriteAnimation _getMoveAnimation({
    required int start,
    required int end,
    required int amount,
    required double stepTime,
    int? amountPerRow,
  }) {
    final List<double> stepTimes = [];
    for (int i = 0; i < amount; i++) {
      stepTimes.add(stepTime);
    }
    return SpriteAnimation.fromFrameData(
      gameRef.images.fromCache(character),
      SpriteAnimationData.range(
        amountPerRow: amountPerRow ?? 4,
        start: start,
        end: end,
        amount: amount,
        stepTimes: stepTimes,
        textureSize: Vector2.all(72),
      ),
    );
  }
}
