// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://www.yoerg.net

#import "ListenerServiceService.h"

@implementation SendPORequest
SOAP_TYPE_BEGIN(@"http://www.yoerg.net", @"sendPORequest")
    SOAP_ELEMENT(customerId, @"customerId"),
    SOAP_ELEMENT(purchaseOrderNumber, @"purchaseOrderNumber"),
    SOAP_ELEMENT(productId, @"productId"),
    SOAP_ELEMENT(quantity, @"quantity")
SOAP_TYPE_END
@end

@implementation Correlationset
SOAP_TYPE_BEGIN(@"http://www.yoerg.net", @"correlationset")
    SOAP_ELEMENT(purchaseOrder, @"PurchaseOrder")
SOAP_TYPE_END
@end

@implementation SendScheduleRequest
SOAP_TYPE_BEGIN(@"http://www.yoerg.net", @"sendScheduleRequest")
    SOAP_ELEMENT(shipDate, @"shipDate"),
    SOAP_ELEMENT(customerId, @"customerId"),
    SOAP_ELEMENT(purchaseOrderNumber, @"purchaseOrderNumber")
SOAP_TYPE_END
@end

@implementation SendInvoiceRequest
SOAP_TYPE_BEGIN(@"http://www.yoerg.net", @"sendInvoiceRequest")
    SOAP_ELEMENT(price, @"price"),
    SOAP_ELEMENT(customerId, @"customerId"),
    SOAP_ELEMENT(purchaseOrderNumber, @"purchaseOrderNumber")
SOAP_TYPE_END
@end

@implementation Correlationsetvalues
SOAP_TYPE_BEGIN(@"http://www.yoerg.net", @"correlationsetvalues")
    SOAP_ELEMENT(purchaseOrderNumber, @"PurchaseOrderNumber"),
    SOAP_ELEMENT(customerID, @"customerID")
SOAP_TYPE_END
@end

@implementation ListenerServiceService
SOAP_SERVICE(@"http://localhost:8080/axis/services/ListenerService", SOAPVersionV1_1)

- (void)sendMyPurchaseOrderWithSendPurchaseOrderBody:(SendPORequest *)sendPurchaseOrderBody correlationsBody:(Correlationset *)correlationsBody portTypeBody:(NSString *)portTypeBody partnerLinkBody:(NSString *)partnerLinkBody
              completion:(void (^)(NSObject * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"sendMyPurchaseOrder"
                soapAction:@""
                 bodyParts:@[@{@"wireName": @"sendPurchaseOrder", @"payload": sendPurchaseOrderBody}, @{@"wireName": @"correlations", @"payload": correlationsBody}, @{@"wireName": @"portType", @"payload": portTypeBody}, @{@"wireName": @"partnerLink", @"payload": partnerLinkBody}]
             bodyNamespace:@"http://www.yoerg.net"
             responseClass:Nil
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)sendMyScheduleWithSendScheduleBody:(SendScheduleRequest *)sendScheduleBody correlationBody:(Correlationset *)correlationBody portTypeBody:(NSString *)portTypeBody partnerLinkBody:(NSString *)partnerLinkBody
              completion:(void (^)(NSObject * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"sendMySchedule"
                soapAction:@""
                 bodyParts:@[@{@"wireName": @"sendSchedule", @"payload": sendScheduleBody}, @{@"wireName": @"correlations", @"payload": correlationBody}, @{@"wireName": @"portType", @"payload": portTypeBody}, @{@"wireName": @"partnerLink", @"payload": partnerLinkBody}]
             bodyNamespace:@"http://www.yoerg.net"
             responseClass:Nil
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)sendInvoiceWithSendInvoiceBody:(SendInvoiceRequest *)sendInvoiceBody correlationsBody:(Correlationset *)correlationsBody portTypeBody:(NSString *)portTypeBody partnerLinkBody:(NSString *)partnerLinkBody
              completion:(void (^)(NSObject * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"sendInvoice"
                soapAction:@""
                 bodyParts:@[@{@"wireName": @"sendInvoice", @"payload": sendInvoiceBody}, @{@"wireName": @"correlations", @"payload": correlationsBody}, @{@"wireName": @"portType", @"payload": portTypeBody}, @{@"wireName": @"partnerLink", @"payload": partnerLinkBody}]
             bodyNamespace:@"http://www.yoerg.net"
             responseClass:Nil
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

@end

