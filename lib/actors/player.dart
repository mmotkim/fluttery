import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:fluttery/mmotkim.dart';

class Player extends SpriteAnimationGroupComponent with HasGameRef<Mmotkim> {
  late final SpriteAnimation idleAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('Character_001.png'),
      SpriteAnimationData.range(
        start: 0,
        end: 3,
        amount: 4,
        stepTimes: [1],
        textureSize: Vector2.all(48),
      ),
    );
  }
}
