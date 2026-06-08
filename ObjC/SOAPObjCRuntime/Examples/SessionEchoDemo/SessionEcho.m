// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:SessionEcho

#import "SessionEcho.h"

@implementation SessionHeader
SOAP_TYPE_BEGIN(@"urn:SessionEcho", @"SessionHeader")
    SOAP_ELEMENT(token, @"token")
SOAP_TYPE_END
@end

@implementation EchoRequest
SOAP_TYPE_BEGIN(@"urn:SessionEcho", @"EchoRequest")
    SOAP_ELEMENT(text, @"text")
SOAP_TYPE_END
@end

@implementation EchoResponse
SOAP_TYPE_BEGIN(@"urn:SessionEcho", @"EchoResponse")
    SOAP_ELEMENT(text, @"text")
SOAP_TYPE_END
@end

@implementation SessionEchoService
SOAP_SERVICE(@"https://example.com/Echo", SOAPVersionV1_1)

- (void)echoWithParameters:(EchoRequest *)parameters sessionHeader:(SessionHeader *)sessionHeader
              completion:(void (^)(EchoResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"Echo"
                soapAction:@"urn:SessionEcho/Echo"
                   request:parameters
             responseClass:EchoResponse.class
                   headers:@[sessionHeader]
                completion:(void (^)(id, NSError *))completion];
}

@end

@interface SessionHeader (SOAPHeaderAdoption) <SOAPHeader> @end
@implementation SessionHeader (SOAPHeaderAdoption) @end

