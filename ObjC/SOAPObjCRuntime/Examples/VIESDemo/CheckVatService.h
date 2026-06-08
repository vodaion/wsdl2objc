// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:ec.europa.eu:taxud:vies:services:checkVat

#import <Foundation/Foundation.h>
@import SOAPObjCRuntime;
#import "Ns1.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckVatService : SOAPService
- (void)checkVatWithParameters:(CheckVat *)parameters
              completion:(void (^)(CheckVatResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)checkVatApproxWithParameters:(CheckVatApprox *)parameters
              completion:(void (^)(CheckVatApproxResponse * _Nullable response, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
