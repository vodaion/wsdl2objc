// Compile-only verification — no live server. Just exercises the typed
// SOAP-header surface that the emitter produces.

#import <Foundation/Foundation.h>
#import "SessionEcho.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        SessionEchoService *service = [SessionEchoService new];
        EchoRequest *req = [EchoRequest new];
        req.text = @"hi";
        SessionHeader *header = [SessionHeader new];
        header.token = @"tok-123";

        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        [service echoWithParameters:req
                       sessionHeader:header
                          completion:^(EchoResponse *response, NSError *error) {
            // example.com/Echo doesn't reply for real — we don't care about
            // the response here. The point is that the call compiles and the
            // header type is plumbed through.
            (void)response; (void)error;
            dispatch_group_leave(group);
        }];

        // Drop the group; this is a compile-time smoke test.
        (void)group;
    }
    return 0;
}
