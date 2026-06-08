// Compile-only verification — the local axis service obviously isn't running.
// Exercises the multi-part body emitter output and the one-way operation
// shape (no response, completion handler still fires when the transport
// returns).

#import <Foundation/Foundation.h>
#import "ListenerServiceService.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        ListenerServiceService *service = [ListenerServiceService new];

        SendPORequest *order = [SendPORequest new];
        order.customerId = @1;
        order.purchaseOrderNumber = @2;
        order.productId = @3;
        order.quantity = @4;

        Correlationsetvalues *values = [Correlationsetvalues new];
        values.purchaseOrderNumber = @"P";
        values.customerID = @"C";
        Correlationset *corr = [Correlationset new];
        corr.purchaseOrder = values;

        [service sendMyPurchaseOrderWithSendPurchaseOrderBody:order
                                            correlationsBody:corr
                                                portTypeBody:@"purchaseOrderPortType"
                                              partnerLinkBody:@"buyer"
                                                   completion:^(NSObject *response, NSError *error) {
            (void)response; (void)error;
        }];
    }
    return 0;
}
