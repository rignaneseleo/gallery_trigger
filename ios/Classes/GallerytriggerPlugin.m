#import "GallerytriggerPlugin.h"
#if __has_include(<gallerytrigger/gallerytrigger-Swift.h>)
#import <gallerytrigger/gallerytrigger-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "gallerytrigger-Swift.h"
#endif

@implementation GallerytriggerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGallerytriggerPlugin registerWithRegistrar:registrar];
}
@end
