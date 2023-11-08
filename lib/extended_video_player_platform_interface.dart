import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'extended_video_player_method_channel.dart';

abstract class ExtendedVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a ExtendedVideoPlayerPlatform.
  ExtendedVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ExtendedVideoPlayerPlatform _instance = MethodChannelExtendedVideoPlayer();

  /// The default instance of [ExtendedVideoPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelExtendedVideoPlayer].
  static ExtendedVideoPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ExtendedVideoPlayerPlatform] when
  /// they register themselves.
  static set instance(ExtendedVideoPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
