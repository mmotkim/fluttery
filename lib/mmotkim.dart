import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:fluttery/actors/player.dart';
import 'package:fluttery/worlds/world.dart';

class Mmotkim extends FlameGame {
  late final CameraComponent cam;

  final world = MapWorld(mapAsset: 'GrassLands.tmx');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages(); //Change to specific images later on
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 2560,
      height: 1440,
    );
    cam.viewfinder.anchor = Anchor.center;
    final cameraComponent = CameraComponent(world: world);
    addAll([cameraComponent, world]);
    add(Player());

    return super.onLoad();
  }
}
