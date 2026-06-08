#import "SOAPFault.h"

NSString *const SOAPFaultKey = @"SOAPFault";

@implementation SOAPFault

- (instancetype)initWithCode:(NSString *)code
                       reason:(NSString *)reason
                       detail:(NSString *)detail
                   httpStatus:(NSInteger)httpStatus {
    if ((self = [super init])) {
        _code = [code copy];
        _reason = [reason copy];
        _detail = [detail copy];
        _httpStatus = httpStatus;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<SOAPFault code=%@ reason=%@ http=%ld>",
        self.code, self.reason, (long)self.httpStatus];
}

@end
