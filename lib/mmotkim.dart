import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:fluttery/worlds/world.dart';

class Mmotkim extends FlameGame {
  late final CameraComponent cam;

  final world = MapWorld(mapAsset: 'GrassLands.tmx');

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 2560, height: 1440);
    cam.viewfinder.anchor = Anchor.topLeft;
    
    addAll([cam, world]);

    return super.onLoad();
  }
}
