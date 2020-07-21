#import "OpenDocumentPlugin.h"
#if __has_include(<open_document/open_document-Swift.h>)
#import <open_document/open_document-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "open_document-Swift.h"
#endif

@implementation OpenDocumentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenDocumentPlugin registerWithRegistrar:registrar];
}
@end
