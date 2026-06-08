#import <Foundation/Foundation.h>
#import "SOAPVersion.h"
#import "SOAPClient.h"
#import "SOAPHeader.h"

@class SOAPModel;

NS_ASSUME_NONNULL_BEGIN

/// Base class for generated SOAP service actors. Subclasses declare their
/// endpoint and version via `SOAP_SERVICE(...)`. The base provides a single
/// helper, `invokeOperation:...`, that each generated operation method
/// delegates to in one line.
@interface SOAPService : NSObject

@property (nonatomic, readonly) SOAPClient *client;

/// Override via `SOAP_SERVICE(@"https://endpoint", SOAPVersionV1_1)`.
+ (NSURL *)soapEndpointURL;
+ (SOAPVersion)soapVersion;

- (instancetype)initWithSession:(nullable NSURLSession *)session
                   authProvider:(nullable id<SOAPAuthProvider>)authProvider
                 headerProvider:(nullable id<SOAPHeaderProvider>)headerProvider
    NS_DESIGNATED_INITIALIZER;
- (instancetype)init;
- (instancetype)initWithSession:(nullable NSURLSession *)session;

/// Single-body-part operation. The runtime encodes `request` via its
/// `encodeSOAPBody:`, wraps in the envelope, sends via the client, finds the
/// response element matching `responseClass.soapName`, and decodes.
- (void)invokeOperation:(NSString *)operationName
              soapAction:(NSString *)soapAction
                 request:(SOAPModel *)request
            responseClass:(nullable Class)responseClass
                 headers:(nullable NSArray<id<SOAPHeader>> *)headers
              completion:(void (^)(id _Nullable response, NSError * _Nullable error))completion;

/// Multi-part body operation. `bodies` is an array of `(NSString wireName,
/// id payload)` pairs where payload is either a `SOAPModel` subclass or an
/// NSString / NSNumber / NSDate / etc. that the runtime knows how to render
/// as a primitive body part.
- (void)invokeOperation:(NSString *)operationName
              soapAction:(NSString *)soapAction
              bodyParts:(NSArray<NSDictionary<NSString *, id> *> *)bodyParts
           bodyNamespace:(NSString *)bodyNamespace
            responseClass:(nullable Class)responseClass
                 headers:(nullable NSArray<id<SOAPHeader>> *)headers
              completion:(void (^)(id _Nullable response, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
