#ifndef FLUTTER_PLUGIN_EXTENDED_VIDEO_PLAYER_PLUGIN_H_
#define FLUTTER_PLUGIN_EXTENDED_VIDEO_PLAYER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace extended_video_player {

class ExtendedVideoPlayerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ExtendedVideoPlayerPlugin();

  virtual ~ExtendedVideoPlayerPlugin();

  // Disallow copy and assign.
  ExtendedVideoPlayerPlugin(const ExtendedVideoPlayerPlugin&) = delete;
  ExtendedVideoPlayerPlugin& operator=(const ExtendedVideoPlayerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace extended_video_player

#endif  // FLUTTER_PLUGIN_EXTENDED_VIDEO_PLAYER_PLUGIN_H_
