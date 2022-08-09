
import 'flutter_mold_platform_interface.dart';

class FlutterMold {
  Future<String?> getPlatformVersion() {
    return FlutterMoldPlatform.instance.getPlatformVersion();
  }
}
