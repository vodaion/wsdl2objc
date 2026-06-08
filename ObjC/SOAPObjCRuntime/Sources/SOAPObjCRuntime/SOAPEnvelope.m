#import "SOAPEnvelope.h"

@implementation SOAPEnvelope

+ (NSString *)wrapBody:(NSString *)bodyXML
               headers:(NSArray<id<SOAPHeader>> *)headers
               version:(SOAPVersion)version
                 error:(NSError **)error {
    NSString *envNS = SOAPVersionEnvelopeNamespace(version);
    if (headers.count == 0) {
        return [NSString stringWithFormat:
                @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                 "<soap:Envelope xmlns:soap=\"%@\"><soap:Body>%@</soap:Body></soap:Envelope>",
                envNS, bodyXML];
    }
    NSMutableString *headerXML = [NSMutableString string];
    for (id<SOAPHeader> h in headers) {
        NSError *e = nil;
        NSString *part = [h encodeSOAPHeader:&e];
        if (part == nil) {
            if (error) *error = e;
            return nil;
        }
        [headerXML appendString:part];
    }
    return [NSString stringWithFormat:
            @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
             "<soap:Envelope xmlns:soap=\"%@\"><soap:Header>%@</soap:Header><soap:Body>%@</soap:Body></soap:Envelope>",
            envNS, headerXML, bodyXML];
}

@end
