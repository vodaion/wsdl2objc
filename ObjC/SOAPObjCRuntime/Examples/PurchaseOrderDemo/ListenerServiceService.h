// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://www.yoerg.net

#import <Foundation/Foundation.h>
@import SOAPObjCRuntime;

NS_ASSUME_NONNULL_BEGIN

@class SendPORequest, Correlationset, SendScheduleRequest, SendInvoiceRequest, Correlationsetvalues;

@interface SendPORequest : SOAPModel
@property (nonatomic, strong, nullable) NSNumber *customerId;
@property (nonatomic, strong, nullable) NSNumber *purchaseOrderNumber;
@property (nonatomic, strong, nullable) NSNumber *productId;
@property (nonatomic, strong, nullable) NSNumber *quantity;
@end

@interface Correlationset : SOAPModel
@property (nonatomic, strong, nullable) Correlationsetvalues *purchaseOrder;
@end

@interface SendScheduleRequest : SOAPModel
@property (nonatomic, strong, nullable) NSDate *shipDate;
@property (nonatomic, strong, nullable) NSNumber *customerId;
@property (nonatomic, strong, nullable) NSNumber *purchaseOrderNumber;
@end

@interface SendInvoiceRequest : SOAPModel
@property (nonatomic, strong, nullable) NSNumber *price;
@property (nonatomic, strong, nullable) NSNumber *customerId;
@property (nonatomic, strong, nullable) NSNumber *purchaseOrderNumber;
@end

@interface Correlationsetvalues : SOAPModel
@property (nonatomic, strong, nullable) NSString *purchaseOrderNumber;
@property (nonatomic, strong, nullable) NSString *customerID;
@end

@interface ListenerServiceService : SOAPService
- (void)sendMyPurchaseOrderWithSendPurchaseOrderBody:(SendPORequest *)sendPurchaseOrderBody correlationsBody:(Correlationset *)correlationsBody portTypeBody:(NSString *)portTypeBody partnerLinkBody:(NSString *)partnerLinkBody
              completion:(void (^)(NSObject * _Nullable response, NSError * _Nullable error))completion;
- (void)sendMyScheduleWithSendScheduleBody:(SendScheduleRequest *)sendScheduleBody correlationBody:(Correlationset *)correlationBody portTypeBody:(NSString *)portTypeBody partnerLinkBody:(NSString *)partnerLinkBody
              completion:(void (^)(NSObject * _Nullable response, NSError * _Nullable error))completion;
- (void)sendInvoiceWithSendInvoiceBody:(SendInvoiceRequest *)sendInvoiceBody correlationsBody:(Correlationset *)correlationsBody portTypeBody:(NSString *)portTypeBody partnerLinkBody:(NSString *)partnerLinkBody
              completion:(void (^)(NSObject * _Nullable response, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
