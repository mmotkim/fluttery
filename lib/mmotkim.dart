import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:fluttery/worlds/world.dart';

class Mmotkim extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  // late final CameraComponent cam;

  Mmotkim()
      : super(
          camera: CameraComponent(),
          world: MapWorld(mapAsset: 'GrassLands.tmx'),
        );

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages(); //Change to specific images later on

    // camera.world = world;
    return super.onLoad();
  }
}
