
import 'extended_video_player_platform_interface.dart';

class ExtendedVideoPlayer {
  Future<String?> getPlatformVersion() {
    return ExtendedVideoPlayerPlatform.instance.getPlatformVersion();
  }
}
