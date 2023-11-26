import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:fluttery/worlds/world.dart';

class Mmotkim extends FlameGame with HasKeyboardHandlerComponents {
  late final CameraComponent cam;

  final world = MapWorld(mapAsset: 'GrassLands.tmx');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages(); //Change to specific images later on

    final cam = CameraComponent(world: world);
    // cam.viewport = FixedResolutionViewport(resolution: Vector2(640, 300));       
    // final cam = CameraComponent.withFixedResolution(
    //     world: world, width: 640, height: 320);


    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([world, cam]);

    return super.onLoad();
  }
}
