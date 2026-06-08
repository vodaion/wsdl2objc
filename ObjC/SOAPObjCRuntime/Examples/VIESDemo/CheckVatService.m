// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:ec.europa.eu:taxud:vies:services:checkVat

#import "CheckVatService.h"

@implementation CheckVatService
SOAP_SERVICE(@"http://ec.europa.eu/taxation_customs/vies/services/checkVatService", SOAPVersionV1_1)

- (void)checkVatWithParameters:(CheckVat *)parameters
              completion:(void (^)(CheckVatResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"checkVat"
                soapAction:@""
                   request:parameters
             responseClass:CheckVatResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)checkVatApproxWithParameters:(CheckVatApprox *)parameters
              completion:(void (^)(CheckVatApproxResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"checkVatApprox"
                soapAction:@""
                   request:parameters
             responseClass:CheckVatApproxResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

@end

