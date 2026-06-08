#import "SOAPDateFormatter.h"

@implementation SOAPDateFormatter

+ (NSArray<NSDateFormatter *> *)decodeFormatters {
    static NSArray<NSDateFormatter *> *formatters = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSArray<NSString *> *patterns = @[
            @"yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            @"yyyy-MM-dd'T'HH:mm:ssXXXXX",
            @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            @"yyyy-MM-dd'T'HH:mm:ss'Z'",
            @"yyyy-MM-dd'T'HH:mm:ss.SSS",
            @"yyyy-MM-dd'T'HH:mm:ss",
            @"yyyy-MM-ddXXXXX",   // xs:date with tz offset
            @"yyyy-MM-dd'Z'",
            @"yyyy-MM-dd",
        ];
        NSMutableArray<NSDateFormatter *> *list = [NSMutableArray array];
        for (NSString *pat in patterns) {
            NSDateFormatter *f = [NSDateFormatter new];
            f.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            f.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            f.dateFormat = pat;
            [list addObject:f];
        }
        formatters = [list copy];
    });
    return formatters;
}

+ (NSDateFormatter *)encodeFormatter {
    static NSDateFormatter *f = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        f = [NSDateFormatter new];
        f.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        f.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        f.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    });
    return f;
}

+ (NSDate *)dateFromString:(NSString *)string {
    if (string.length == 0) return nil;
    for (NSDateFormatter *f in [self decodeFormatters]) {
        NSDate *d = [f dateFromString:string];
        if (d != nil) return d;
    }
    return nil;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [[self encodeFormatter] stringFromDate:date];
}

@end
