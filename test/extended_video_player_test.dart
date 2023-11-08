import 'package:flutter_test/flutter_test.dart';
import 'package:extended_video_player/extended_video_player.dart';
import 'package:extended_video_player/extended_video_player_platform_interface.dart';
import 'package:extended_video_player/extended_video_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockExtendedVideoPlayerPlatform
    with MockPlatformInterfaceMixin
    implements ExtendedVideoPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ExtendedVideoPlayerPlatform initialPlatform = ExtendedVideoPlayerPlatform.instance;

  test('$MethodChannelExtendedVideoPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelExtendedVideoPlayer>());
  });

  test('getPlatformVersion', () async {
    ExtendedVideoPlayer extendedVideoPlayerPlugin = ExtendedVideoPlayer();
    MockExtendedVideoPlayerPlatform fakePlatform = MockExtendedVideoPlayerPlatform();
    ExtendedVideoPlayerPlatform.instance = fakePlatform;

    expect(await extendedVideoPlayerPlugin.getPlatformVersion(), '42');
  });
}
