#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SOAPVersion) {
    SOAPVersionV1_1 = 0,
    SOAPVersionV1_2 = 1,
};

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *SOAPVersionContentType(SOAPVersion version);
FOUNDATION_EXPORT NSString *SOAPVersionEnvelopeNamespace(SOAPVersion version);

NS_ASSUME_NONNULL_END
