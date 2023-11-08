import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'extended_video_player_platform_interface.dart';

/// An implementation of [ExtendedVideoPlayerPlatform] that uses method channels.
class MethodChannelExtendedVideoPlayer extends ExtendedVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('extended_video_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
