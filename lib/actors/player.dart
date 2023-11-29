// ignore_for_file: unused_import

import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:fluttery/mmotkim.dart';
import 'package:fluttery/worlds/world.dart';

import '../worlds/collision_block.dart';

enum PlayerState {
  idle,
  moveLeft,
  moveRight,
  moveUp,
  moveDown,
  lookLeft,
  lookRight,
  lookUp,
  lookDown
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<Mmotkim>, KeyboardHandler, CollisionCallbacks {
  Player({
    Vector2? position,
    this.character = 'Character_001.png',
  }) : super(
          position: position,
          priority: 3,
        );

  late final SpriteAnimation faceDown;
  late final SpriteAnimation faceUp;
  late final SpriteAnimation faceLeft;
  late final SpriteAnimation faceRight;
  late final SpriteAnimation moveDown;
  late final SpriteAnimation moveUp;
  late final SpriteAnimation moveLeft;
  late final SpriteAnimation moveRight;
  late final SpriteSheet spriteSheet;
  final String? character;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  bool isMoving = false;
  final double moveSpeed = 168;
  final Vector2 velocity = Vector2.zero();
  static const double acceleration = 0.2;
  var playerState = PlayerState.moveDown;
  final stepTime = 0.15;
  List<CollisionBlock> collisionBlocks = [];
  late ShapeHitbox hitbox;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    _loadHitbox();
    debugMode = false;
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

    isMoving = true;

    if (keyLeft)
      playerState = PlayerState.moveLeft;
    else if (keyRight)
      playerState = PlayerState.moveRight;
    else if (keyDown)
      playerState = PlayerState.moveDown;
    else if (keyUp)
      playerState = PlayerState.moveUp;
    else
      isMoving = false;

    horizontalDirection += keyLeft ? -1 : 0;
    horizontalDirection += keyRight ? 1 : 0;
    verticalDirection += keyDown ? 1 : 0;
    verticalDirection += keyUp ? -1 : 0;

    return true;
  }

  void _loadAllAnimations() {
    spriteSheet = SpriteSheet(
        image: gameRef.images.fromCache(character!), srcSize: Vector2.all(72));
    moveDown = _getMoveAnimation(row: 0, from: 0, to: 4);
    moveLeft = _getMoveAnimation(row: 1, from: 0, to: 4);
    moveRight = _getMoveAnimation(row: 2, from: 0, to: 4);
    moveUp = _getMoveAnimation(row: 3, from: 0, to: 4);

    faceDown = _getMoveAnimation(row: 0);
    faceLeft = _getMoveAnimation(row: 1);
    faceRight = _getMoveAnimation(row: 2);
    faceUp = _getMoveAnimation(row: 3);

    animations = {
      PlayerState.moveDown: moveDown,
      PlayerState.moveLeft: moveLeft,
      PlayerState.moveRight: moveRight,
      PlayerState.moveUp: moveUp,
      PlayerState.lookDown: faceDown,
      PlayerState.lookLeft: faceLeft,
      PlayerState.lookRight: faceRight,
      PlayerState.lookUp: faceUp,
    };
  }

  void _updateDisplay() {
    switch (playerState) {
      case PlayerState.moveDown:
        if (isMoving) {
          playerState = PlayerState.moveDown;
        } else {
          playerState = PlayerState.lookDown;
        }
        break;
      case PlayerState.moveLeft:
        if (isMoving) {
          playerState = PlayerState.moveLeft;
        } else {
          playerState = PlayerState.lookLeft;
        }
        break;
      case PlayerState.moveRight:
        if (isMoving) {
          playerState = PlayerState.moveRight;
        } else {
          playerState = PlayerState.lookRight;
        }
        break;
      case PlayerState.moveUp:
        if (isMoving) {
          playerState = PlayerState.moveUp;
        } else {
          playerState = PlayerState.lookUp;
        }
        break;
      default:
    }

    current = playerState;
  }

  SpriteAnimation _getMoveAnimation({
    required int row,
    int? from,
    int? to,
  }) {
    return spriteSheet.createAnimation(
      row: row,
      stepTime: stepTime,
      from: from ?? 0,
      to: to ?? 1,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print('player COLLIDED');
    velocity.negate();
  }

  void _loadHitbox() {
    final defaultPaint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..debugMode = true;
    add(hitbox);
  }
}
