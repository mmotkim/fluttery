import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:fluttery/worlds/world.dart';

class Mmotkim extends FlameGame {
  late final CameraComponent cam;

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    add(MapWorld(mapAsset: 'GrassLands.tmx'));

    return super.onLoad();
  }
}
