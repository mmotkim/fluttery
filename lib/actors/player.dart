import 'dart:async';

import 'package:flame/components.dart';
import 'package:fluttery/mmotkim.dart';

enum PlayerState {idle, running}
class Player extends SpriteAnimationGroupComponent with HasGameRef<Mmotkim> {
  late final SpriteAnimation faceDown;
  late final String character = 'Character_001.png';

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    faceDown = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache(character),
      SpriteAnimationData.sequenced(

        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2.all(72),
      ),
    );    

    animations = {PlayerState.idle: faceDown};

    current = PlayerState.idle;
  }
}
