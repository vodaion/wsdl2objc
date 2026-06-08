// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:SessionEcho

#import <Foundation/Foundation.h>
@import SOAPObjCRuntime;

NS_ASSUME_NONNULL_BEGIN

@class SessionHeader, EchoRequest, EchoResponse;

@interface SessionHeader : SOAPModel
@property (nonatomic, strong, nullable) NSString *token;
@end

@interface EchoRequest : SOAPModel
@property (nonatomic, strong, nullable) NSString *text;
@end

@interface EchoResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *text;
@end

@interface SessionEchoService : SOAPService
- (void)echoWithParameters:(EchoRequest *)parameters sessionHeader:(SessionHeader *)sessionHeader
              completion:(void (^)(EchoResponse * _Nullable response, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
