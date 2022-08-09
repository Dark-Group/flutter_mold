#ifndef FLUTTER_PLUGIN_FLUTTER_MOLD_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_MOLD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_mold {

class FlutterMoldPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterMoldPlugin();

  virtual ~FlutterMoldPlugin();

  // Disallow copy and assign.
  FlutterMoldPlugin(const FlutterMoldPlugin&) = delete;
  FlutterMoldPlugin& operator=(const FlutterMoldPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_mold

#endif  // FLUTTER_PLUGIN_FLUTTER_MOLD_PLUGIN_H_
