#import <Foundation/Foundation.h>
#import "CheckVatService.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        CheckVatService *service = [CheckVatService new];
        dispatch_group_t group = dispatch_group_create();

        CheckVat *req = [CheckVat new];
        req.countryCode = @"BE";
        req.vatNumber = @"0203049995";

        dispatch_group_enter(group);
        [service checkVatWithParameters:req
                              completion:^(CheckVatResponse *response, NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                printf("country:      %s\n", response.countryCode.UTF8String ?: "");
                printf("vatNumber:    %s\n", response.vatNumber.UTF8String ?: "");
                printf("requestDate:  %s\n", response.requestDate.description.UTF8String ?: "(nil)");
                printf("valid:        %s\n", response.valid.boolValue ? "true" : "false");
                printf("name:         %s\n", response.name.UTF8String ?: "(nil)");
            }
            dispatch_group_leave(group);
        }];

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
    return 0;
}
