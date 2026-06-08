#import "SOAPHeader.h"
#import "SOAPModel.h"

#pragma mark - SOAPFixedHeaderProvider

@implementation SOAPFixedHeaderProvider {
    NSArray<id<SOAPHeader>> *_headers;
}

- (instancetype)initWithHeaders:(NSArray<id<SOAPHeader>> *)headers {
    if ((self = [super init])) {
        _headers = [headers copy];
    }
    return self;
}

- (NSArray<id<SOAPHeader>> *)headersForSOAPAction:(NSString *)action {
    return _headers;
}

@end

#pragma mark - WSSEUsernameToken

static NSString *SOAPXMLEscape(NSString *s) {
    NSMutableString *r = [NSMutableString stringWithCapacity:s.length];
    NSUInteger len = s.length;
    for (NSUInteger i = 0; i < len; i++) {
        unichar c = [s characterAtIndex:i];
        switch (c) {
            case '&':  [r appendString:@"&amp;"];  break;
            case '<':  [r appendString:@"&lt;"];   break;
            case '>':  [r appendString:@"&gt;"];   break;
            case '"':  [r appendString:@"&quot;"]; break;
            case '\'': [r appendString:@"&apos;"]; break;
            default:   [r appendFormat:@"%C", c];
        }
    }
    return r;
}

@implementation WSSEUsernameToken

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password {
    if ((self = [super init])) {
        _username = [username copy];
        _password = [password copy];
    }
    return self;
}

- (NSString *)encodeSOAPHeader:(NSError **)error {
    static NSString *const wsseNS = @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";
    static NSString *const passwordType = @"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText";
    return [NSString stringWithFormat:
            @"<wsse:Security xmlns:wsse=\"%@\">"
             "<wsse:UsernameToken>"
             "<wsse:Username>%@</wsse:Username>"
             "<wsse:Password Type=\"%@\">%@</wsse:Password>"
             "</wsse:UsernameToken>"
             "</wsse:Security>",
            wsseNS,
            SOAPXMLEscape(self.username),
            passwordType,
            SOAPXMLEscape(self.password)];
}

@end

#pragma mark - SOAPModel + SOAPHeader bridge

@interface SOAPModel () <SOAPHeader>
@end

@implementation SOAPModel (SOAPHeaderBridge)
// Default: any SOAPModel subclass can also serve as a SOAP header by simply
// adopting <SOAPHeader>. The encode goes through the regular body encoder.
- (NSString *)encodeSOAPHeader:(NSError **)error {
    return [self encodeSOAPBody:error];
}
@end
