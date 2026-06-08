#import <Foundation/Foundation.h>
#import "TemperatureConversions.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        TemperatureConversionsService *service = [TemperatureConversionsService new];

        dispatch_group_t group = dispatch_group_create();

        CelsiusToFahrenheit *req1 = [CelsiusToFahrenheit new];
        req1.nCelsius = [NSDecimalNumber decimalNumberWithString:@"100"];

        dispatch_group_enter(group);
        [service celsiusToFahrenheitWithParameters:req1
                                         completion:^(CelsiusToFahrenheitResponse *response, NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                printf("100°C = %s°F\n", response.celsiusToFahrenheitResult.stringValue.UTF8String);
            }
            dispatch_group_leave(group);
        }];

        FahrenheitToCelsius *req2 = [FahrenheitToCelsius new];
        req2.nFahrenheit = [NSDecimalNumber decimalNumberWithString:@"100"];

        dispatch_group_enter(group);
        [service fahrenheitToCelsiusWithParameters:req2
                                         completion:^(FahrenheitToCelsiusResponse *response, NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                printf("100°F = %s°C\n", response.fahrenheitToCelsiusResult.stringValue.UTF8String);
            }
            dispatch_group_leave(group);
        }];

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
    return 0;
}
