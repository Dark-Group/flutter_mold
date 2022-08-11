import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mold/flutter_mold.dart';
import 'package:flutter_mold/flutter_mold_platform_interface.dart';
import 'package:flutter_mold/flutter_mold_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMoldPlatform 
    with MockPlatformInterfaceMixin
    implements FlutterMoldPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMoldPlatform initialPlatform = FlutterMoldPlatform.instance;

  test('$MethodChannelFlutterMold is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMold>());
  });

  test('getPlatformVersion', () async {
    FlutterMold flutterMoldPlugin = FlutterMold();
    MockFlutterMoldPlatform fakePlatform = MockFlutterMoldPlatform();
    FlutterMoldPlatform.instance = fakePlatform;
  
    expect(await flutterMoldPlugin.getPlatformVersion(), '42');
  });
}
