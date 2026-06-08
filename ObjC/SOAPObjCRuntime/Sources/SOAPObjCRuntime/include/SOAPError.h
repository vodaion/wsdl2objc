#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSErrorDomain const SOAPErrorDomain;

typedef NS_ERROR_ENUM(SOAPErrorDomain, SOAPErrorCode) {
    SOAPErrorCodeNonHTTPResponse        = 1,
    SOAPErrorCodeInvalidMIMEType        = 2,
    SOAPErrorCodeEmptyBody              = 3,
    SOAPErrorCodeDecoding               = 4,
    SOAPErrorCodeEncoding               = 5,
    SOAPErrorCodeFault                  = 6,
    SOAPErrorCodeMissingElement         = 7,
    SOAPErrorCodeUnsupportedType        = 8,
};

NS_ASSUME_NONNULL_END
