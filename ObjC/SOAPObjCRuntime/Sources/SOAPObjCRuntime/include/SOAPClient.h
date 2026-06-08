#import <Foundation/Foundation.h>
#import "SOAPVersion.h"
#import "SOAPHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SOAPAuthProvider <NSObject>
- (void)authenticateRequest:(NSMutableURLRequest *)request
                 completion:(void (^)(NSError * _Nullable error))completion;
@end

/// Async SOAP transport over NSURLSession. ObjC callers use completion
/// blocks; Swift callers get `async throws` thanks to `NS_SWIFT_ASYNC`.
@interface SOAPClient : NSObject

@property (nonatomic, readonly) NSURL *endpointURL;
@property (nonatomic, readonly) SOAPVersion soapVersion;
@property (nonatomic, readonly) NSURLSession *session;
@property (nonatomic, strong, nullable) id<SOAPAuthProvider> authProvider;
@property (nonatomic, strong, nullable) id<SOAPHeaderProvider> headerProvider;
@property (nonatomic) BOOL logTraffic;

- (instancetype)initWithEndpointURL:(NSURL *)endpoint
                         soapVersion:(SOAPVersion)version
                             session:(nullable NSURLSession *)session
                        authProvider:(nullable id<SOAPAuthProvider>)authProvider
                      headerProvider:(nullable id<SOAPHeaderProvider>)headerProvider
    NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

/// POSTs a SOAP envelope built from `bodyXML` (already-serialized body
/// content) and `headers`, returning the raw response data via the
/// completion block. The `error` is non-nil for HTTP / SOAP-fault errors.
- (void)sendBody:(NSString *)bodyXML
      soapAction:(NSString *)soapAction
         headers:(nullable NSArray<id<SOAPHeader>> *)headers
      completion:(void (^)(NSData * _Nullable response, NSError * _Nullable error))completion
    NS_SWIFT_ASYNC_NAME(send(body:soapAction:headers:));

@end

NS_ASSUME_NONNULL_END
