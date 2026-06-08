#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// xs:date and xs:dateTime parser. Tries 9 common patterns from bare
/// `2026-06-05` through `2026-06-05T12:34:56.789+02:00`. Mirrors the
/// Swift-side `SOAPDateFormat`.
@interface SOAPDateFormatter : NSObject

+ (nullable NSDate *)dateFromString:(NSString *)string;

/// Canonical xs:dateTime form used when encoding: `yyyy-MM-dd'T'HH:mm:ss'Z'`.
+ (NSString *)stringFromDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
