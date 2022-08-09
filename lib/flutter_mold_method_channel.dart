import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_mold_platform_interface.dart';

/// An implementation of [FlutterMoldPlatform] that uses method channels.
class MethodChannelFlutterMold extends FlutterMoldPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_mold');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
