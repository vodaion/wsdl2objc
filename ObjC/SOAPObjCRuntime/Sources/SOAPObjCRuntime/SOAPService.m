#import "SOAPService.h"
#import "SOAPModel.h"
#import "SOAPDateFormatter.h"
#import "SOAPError.h"

#pragma mark - Body-part rendering

static NSString *XMLEscape(NSString *s) {
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

static NSString *RenderBodyPart(NSString *wireName, NSString *namespace, id payload, NSError **error) {
    if ([payload isKindOfClass:[SOAPModel class]]) {
        return [(SOAPModel *)payload encodeSOAPBodyWithRootName:wireName error:error];
    }
    NSString *nsAttr = namespace.length ? [NSString stringWithFormat:@" xmlns=\"%@\"", namespace] : @"";
    NSString *text = nil;
    if ([payload isKindOfClass:[NSString class]]) {
        text = XMLEscape(payload);
    } else if ([payload isKindOfClass:[NSDate class]]) {
        text = [SOAPDateFormatter stringFromDate:payload];
    } else if ([payload isKindOfClass:[NSNumber class]]) {
        text = [(NSNumber *)payload stringValue];
    } else {
        text = XMLEscape([payload description]);
    }
    return [NSString stringWithFormat:@"<%@%@>%@</%@>", wireName, nsAttr, text, wireName];
}

#pragma mark - SOAPService

@implementation SOAPService

+ (NSURL *)soapEndpointURL { return [NSURL URLWithString:@""]; }
+ (SOAPVersion)soapVersion { return SOAPVersionV1_1; }

- (instancetype)initWithSession:(NSURLSession *)session
                   authProvider:(id<SOAPAuthProvider>)authProvider
                 headerProvider:(id<SOAPHeaderProvider>)headerProvider {
    if ((self = [super init])) {
        _client = [[SOAPClient alloc] initWithEndpointURL:[[self class] soapEndpointURL]
                                              soapVersion:[[self class] soapVersion]
                                                  session:session
                                             authProvider:authProvider
                                           headerProvider:headerProvider];
    }
    return self;
}

- (instancetype)init {
    return [self initWithSession:nil authProvider:nil headerProvider:nil];
}

- (instancetype)initWithSession:(NSURLSession *)session {
    return [self initWithSession:session authProvider:nil headerProvider:nil];
}

- (void)invokeOperation:(NSString *)operationName
              soapAction:(NSString *)soapAction
                 request:(SOAPModel *)request
            responseClass:(Class)responseClass
                 headers:(NSArray<id<SOAPHeader>> *)headers
              completion:(void (^)(id _Nullable, NSError * _Nullable))completion {

    NSError *encodeError = nil;
    NSString *bodyXML = [request encodeSOAPBody:&encodeError];
    if (bodyXML == nil) {
        completion(nil, encodeError);
        return;
    }
    [self.client sendBody:bodyXML
                soapAction:soapAction
                   headers:headers
                completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        if (responseClass == nil) {
            completion(nil, nil);
            return;
        }
        NSError *decodeError = nil;
        id response = [responseClass decodeSOAPResponse:data
                                           operationName:operationName
                                                   error:&decodeError];
        completion(response, decodeError);
    }];
}

- (void)invokeOperation:(NSString *)operationName
              soapAction:(NSString *)soapAction
              bodyParts:(NSArray<NSDictionary<NSString *, id> *> *)bodyParts
           bodyNamespace:(NSString *)bodyNamespace
            responseClass:(Class)responseClass
                 headers:(NSArray<id<SOAPHeader>> *)headers
              completion:(void (^)(id _Nullable, NSError * _Nullable))completion {

    NSMutableString *bodyXML = [NSMutableString string];
    for (NSDictionary *part in bodyParts) {
        NSString *wire = part[@"wireName"] ?: part[@"name"];
        id payload = part[@"payload"] ?: part[@"value"];
        if (wire == nil || payload == nil) continue;
        NSError *e = nil;
        NSString *rendered = RenderBodyPart(wire, bodyNamespace, payload, &e);
        if (rendered == nil) {
            completion(nil, e);
            return;
        }
        [bodyXML appendString:rendered];
    }
    [self.client sendBody:bodyXML
                soapAction:soapAction
                   headers:headers
                completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        if (responseClass == nil) {
            completion(nil, nil);
            return;
        }
        NSError *decodeError = nil;
        id response = [responseClass decodeSOAPResponse:data
                                           operationName:operationName
                                                   error:&decodeError];
        completion(response, decodeError);
    }];
}

@end
