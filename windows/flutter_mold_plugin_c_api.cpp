#include "include/flutter_mold/flutter_mold_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_mold_plugin.h"

void FlutterMoldPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_mold::FlutterMoldPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
