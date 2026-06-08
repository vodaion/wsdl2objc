#import "SOAPVersion.h"

NSString *SOAPVersionContentType(SOAPVersion version) {
    switch (version) {
        case SOAPVersionV1_1: return @"text/xml; charset=utf-8";
        case SOAPVersionV1_2: return @"application/soap+xml; charset=utf-8";
    }
}

NSString *SOAPVersionEnvelopeNamespace(SOAPVersion version) {
    switch (version) {
        case SOAPVersionV1_1: return @"http://schemas.xmlsoap.org/soap/envelope/";
        case SOAPVersionV1_2: return @"http://www.w3.org/2003/05/soap-envelope";
    }
}
