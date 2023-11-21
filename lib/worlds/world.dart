import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:fluttery/actors/player.dart';

class MapWorld extends World {
  late TiledComponent level;
  final String mapAsset;

  MapWorld({
    super.children,
    super.priority,
    required this.mapAsset,
  });

  Future<void> init() async {
    level = await TiledComponent.load(
      mapAsset,
      Vector2.all(16),
      prefix: "assets/tiles/",
      images: Images(prefix: 'assets/'),
    );
    final player = Player();
    player.priority = 5;
    await add(level);
    await add(player);
  }

  @override
  FutureOr<void> onLoad() async {
    await init();
    return super.onLoad();
  }
}
