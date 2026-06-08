#import <Foundation/Foundation.h>
#import "SOAPVersion.h"
#import "SOAPHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SOAPEnvelope : NSObject

/// Wraps `bodyXML` in `<soap:Envelope><soap:Body>...</soap:Body></soap:Envelope>`.
/// If `headers` is non-empty, also emits the `<soap:Header>` block before the
/// body.
+ (nullable NSString *)wrapBody:(NSString *)bodyXML
                        headers:(nullable NSArray<id<SOAPHeader>> *)headers
                        version:(SOAPVersion)version
                          error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
