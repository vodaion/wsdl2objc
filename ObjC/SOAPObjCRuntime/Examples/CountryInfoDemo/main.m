#import <Foundation/Foundation.h>
#import "CountryInfoService.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        CountryInfoService *service = [CountryInfoService new];
        dispatch_group_t group = dispatch_group_create();
        ListOfContinentsByName *req = [ListOfContinentsByName new];

        dispatch_group_enter(group);
        [service listOfContinentsByNameWithParameters:req
                                            completion:^(ListOfContinentsByNameResponse *response,
                                                         NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                printf("Continents:\n");
                for (TContinent *c in response.listOfContinentsByNameResult.tContinent) {
                    printf("  %s  %s\n", c.sCode.UTF8String ?: "??", c.sName.UTF8String ?: "??");
                }
            }
            dispatch_group_leave(group);
        }];

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
    return 0;
}
