#import "SOAPClient.h"
#import "SOAPEnvelope.h"
#import "SOAPError.h"
#import "SOAPFault.h"
#import "SOAPXMLNode.h"

@implementation SOAPClient

- (instancetype)initWithEndpointURL:(NSURL *)endpoint
                         soapVersion:(SOAPVersion)version
                             session:(NSURLSession *)session
                        authProvider:(id<SOAPAuthProvider>)authProvider
                      headerProvider:(id<SOAPHeaderProvider>)headerProvider {
    if ((self = [super init])) {
        _endpointURL = [endpoint copy];
        _soapVersion = version;
        _session = session ?: [NSURLSession sharedSession];
        _authProvider = authProvider;
        _headerProvider = headerProvider;
    }
    return self;
}

- (void)sendBody:(NSString *)bodyXML
      soapAction:(NSString *)soapAction
         headers:(NSArray<id<SOAPHeader>> *)headers
      completion:(void (^)(NSData * _Nullable, NSError * _Nullable))completion {

    NSMutableArray<id<SOAPHeader>> *allHeaders = [NSMutableArray array];
    if (self.headerProvider) {
        NSArray *providerHeaders = [self.headerProvider headersForSOAPAction:soapAction];
        if (providerHeaders.count) [allHeaders addObjectsFromArray:providerHeaders];
    }
    if (headers.count) [allHeaders addObjectsFromArray:headers];

    NSError *wrapError = nil;
    NSString *envelope = [SOAPEnvelope wrapBody:bodyXML
                                         headers:allHeaders
                                         version:self.soapVersion
                                           error:&wrapError];
    if (envelope == nil) {
        completion(nil, wrapError);
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.endpointURL
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:60];
    request.HTTPMethod = @"POST";
    [request setValue:SOAPVersionContentType(self.soapVersion) forHTTPHeaderField:@"Content-Type"];
    if (soapAction.length) {
        [request setValue:[NSString stringWithFormat:@"\"%@\"", soapAction]
       forHTTPHeaderField:@"SOAPAction"];
    }
    [request setValue:@"wsdl2soap-objc" forHTTPHeaderField:@"User-Agent"];
    request.HTTPBody = [envelope dataUsingEncoding:NSUTF8StringEncoding];

    void (^dispatchTask)(void) = ^{
        if (self.logTraffic) NSLog(@"--> POST %@\n%@", self.endpointURL.absoluteString, envelope);
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data,
                                                                           NSURLResponse * _Nullable response,
                                                                           NSError * _Nullable error) {
            if (error) {
                completion(nil, error);
                return;
            }
            NSHTTPURLResponse *http = (NSHTTPURLResponse *)response;
            if (![http isKindOfClass:[NSHTTPURLResponse class]]) {
                completion(nil, [NSError errorWithDomain:SOAPErrorDomain
                                                     code:SOAPErrorCodeNonHTTPResponse
                                                 userInfo:nil]);
                return;
            }
            if (self.logTraffic) NSLog(@"<-- %ld\n%@",
                (long)http.statusCode,
                [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

            NSString *mime = [http valueForHTTPHeaderField:@"Content-Type"] ?: @"";
            if (![mime containsString:@"xml"]) {
                completion(nil, [NSError errorWithDomain:SOAPErrorDomain
                                                     code:SOAPErrorCodeInvalidMIMEType
                                                 userInfo:@{NSLocalizedDescriptionKey: mime}]);
                return;
            }
            if (data.length == 0) {
                completion(nil, [NSError errorWithDomain:SOAPErrorDomain
                                                     code:SOAPErrorCodeEmptyBody
                                                 userInfo:nil]);
                return;
            }
            completion(data, nil);
        }];
        [task resume];
    };

    if (self.authProvider) {
        [self.authProvider authenticateRequest:request completion:^(NSError * _Nullable authError) {
            if (authError) {
                completion(nil, authError);
                return;
            }
            dispatchTask();
        }];
    } else {
        dispatchTask();
    }
}

@end
