import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class MapWorld extends World {
  late TiledComponent level;
  final String mapAsset;

  MapWorld({
    super.children,
    super.priority,
    required this.mapAsset,
  });

  Future<void> mapWorldInit() async {
    level = await TiledComponent.load(mapAsset, Vector2.all(16));
    add(level);
  }

  @override
  FutureOr<void> onLoad() {
    mapWorldInit();
    return super.onLoad();
  }
}
