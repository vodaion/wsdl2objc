// Test fixtures for the xs:date / xs:dateTime parser used by SOAPModel.

#import <XCTest/XCTest.h>
@import SOAPObjCRuntime;

@interface SOAPDateFormatterTests : XCTestCase
@end

@implementation SOAPDateFormatterTests

- (NSDateComponents *)utcComponentsFromDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|
                            NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                  fromDate:date];
}

- (void)testParsesXSDateWithTimezone {
    // The exact wire format VIES returns for requestDate.
    NSDate *d = [SOAPDateFormatter dateFromString:@"2026-06-05+02:00"];
    XCTAssertNotNil(d);
    NSDateComponents *c = [self utcComponentsFromDate:d];
    XCTAssertEqual(c.year, 2026);
    XCTAssertEqual(c.month, 6);
    XCTAssertEqual(c.day, 4);
    XCTAssertEqual(c.hour, 22);  // 2026-06-05 00:00 +02:00 == 2026-06-04 22:00 UTC
}

- (void)testParsesBareXSDate {
    NSDate *d = [SOAPDateFormatter dateFromString:@"2026-06-05"];
    XCTAssertNotNil(d);
    NSDateComponents *c = [self utcComponentsFromDate:d];
    XCTAssertEqual(c.year, 2026);
    XCTAssertEqual(c.month, 6);
    XCTAssertEqual(c.day, 5);
    XCTAssertEqual(c.hour, 0);
}

- (void)testParsesXSDateTimeWithZ {
    NSDate *d = [SOAPDateFormatter dateFromString:@"2026-06-05T12:34:56Z"];
    XCTAssertNotNil(d);
    NSDateComponents *c = [self utcComponentsFromDate:d];
    XCTAssertEqual(c.year, 2026);
    XCTAssertEqual(c.hour, 12);
    XCTAssertEqual(c.minute, 34);
    XCTAssertEqual(c.second, 56);
}

- (void)testParsesXSDateTimeWithOffset {
    NSDate *a = [SOAPDateFormatter dateFromString:@"2026-06-05T12:34:56+02:00"];
    NSDate *b = [SOAPDateFormatter dateFromString:@"2026-06-05T10:34:56Z"];
    XCTAssertNotNil(a);
    XCTAssertNotNil(b);
    XCTAssertEqualWithAccuracy(a.timeIntervalSince1970, b.timeIntervalSince1970, 1.0);
}

- (void)testParsesXSDateTimeWithMillis {
    NSDate *a = [SOAPDateFormatter dateFromString:@"2026-06-05T12:34:56.789Z"];
    NSDate *b = [SOAPDateFormatter dateFromString:@"2026-06-05T12:34:56Z"];
    XCTAssertEqualWithAccuracy(a.timeIntervalSince1970 - b.timeIntervalSince1970, 0.789, 0.01);
}

- (void)testRejectsGarbage {
    XCTAssertNil([SOAPDateFormatter dateFromString:@"not-a-date"]);
    XCTAssertNil([SOAPDateFormatter dateFromString:@""]);
}

- (void)testEncodeIsCanonicalUTC {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:1780662896];  // 2026-06-05 12:34:56 UTC
    XCTAssertEqualObjects([SOAPDateFormatter stringFromDate:d], @"2026-06-05T12:34:56Z");
}

@end
