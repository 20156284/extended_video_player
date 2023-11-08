#include "include/extended_video_player/extended_video_player_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "extended_video_player_plugin.h"

void ExtendedVideoPlayerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  extended_video_player::ExtendedVideoPlayerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
