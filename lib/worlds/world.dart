import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:fluttery/actors/player.dart';

import 'collision_block.dart';

class MapWorld extends World with HasGameReference {
  late TiledComponent level;
  final String mapAsset;
  static const String spawnPoint = 'SpawnPoints';
  static final String collisions = 'Collisions';
  late Player player;
  // late CameraComponent cam;
  List<CollisionBlock> collisionBlocks = [];
  static const double size = 1500;
  static final Rectangle bounds = Rectangle.fromLTRB(-size, -size, size, size);

  MapWorld({
    super.children,
    super.priority,
    required this.mapAsset,
  });

  Future<void> init() async {
    level = await TiledComponent.load(
      mapAsset,
      Vector2.all(16),
    );
    // print(parent?.children.elementAt(0));
    loadSpawn();
    addCollisions();
    await add(player);
    await add(level);
    game.camera.viewport.anchor = Anchor.center;
    // game.camera.setBounds(bounds);
    // game.camera.follow(player, maxSpeed: 150);
    // game.camera.viewfinder.visibleGameSize = level.size / 6;
  }

  @override
  FutureOr<void> onLoad() async {
    await init();
    debugMode = false;
    return super.onLoad();
  }

  void addCollisions() async {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>(collisions);
    if (collisionLayer == null) return;

    for (final collision in collisionLayer.objects) {
      switch (collision.class_) {
        case 'Bushes':
          final bush = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisionBlocks.add(bush);
          await add(bush);
          break;
        default:
      }
    }
    // player.collisionBlocks = collisionBlocks;
  }

  void loadSpawn() async {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>(spawnPoint);
    if (spawnPointsLayer == null) return;
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player = Player(position: Vector2(spawnPoint.x, spawnPoint.y));
          break;
        default:
      }
    }
  }
}
