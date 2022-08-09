#import "FlutterMoldPlugin.h"
#if __has_include(<flutter_mold/flutter_mold-Swift.h>)
#import <flutter_mold/flutter_mold-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_mold-Swift.h"
#endif

@implementation FlutterMoldPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMoldPlugin registerWithRegistrar:registrar];
}
@end
