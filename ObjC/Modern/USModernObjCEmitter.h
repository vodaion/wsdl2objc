#import <Foundation/Foundation.h>

@class USWSDL;

/// Walks the parsed WSDL graph and emits modern Objective-C source (one
/// `.h` and one `.m` per schema) that uses the `SOAPObjCRuntime` macros
/// + `SOAPModel` / `SOAPService` base classes — the ObjC parallel of
/// `USSwiftEmitter`.
@interface USModernObjCEmitter : NSObject {
    USWSDL *wsdl;
    NSURL *outDir;
    NSMutableSet *headerTypeNames;
}

@property (nonatomic, retain) USWSDL *wsdl;
@property (nonatomic, copy) NSURL *outDir;
@property (nonatomic, retain) NSMutableSet *headerTypeNames;

- (id)initWithWSDL:(USWSDL *)aWSDL outputDirectory:(NSURL *)anOutDir;
- (BOOL)write;

@end
