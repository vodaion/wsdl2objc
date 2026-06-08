#import <Foundation/Foundation.h>

@class USWSDL;

@interface USSwiftEmitter : NSObject {
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
