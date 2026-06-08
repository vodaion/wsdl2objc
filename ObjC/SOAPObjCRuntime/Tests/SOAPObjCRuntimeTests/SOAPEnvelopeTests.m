#import <XCTest/XCTest.h>
@import SOAPObjCRuntime;

@interface SOAPEnvelopeTests : XCTestCase
@end

@implementation SOAPEnvelopeTests

- (void)testEnvelopeWithoutHeadersOmitsHeaderBlock {
    NSError *err = nil;
    NSString *env = [SOAPEnvelope wrapBody:@"<Foo/>"
                                  headers:nil
                                  version:SOAPVersionV1_1
                                    error:&err];
    XCTAssertNil(err);
    XCTAssertFalse([env containsString:@"<soap:Header"]);
    XCTAssertTrue([env containsString:@"<soap:Body><Foo/></soap:Body>"]);
}

- (void)testEnvelopeWithHeadersWrapsHeaderBlock {
    WSSEUsernameToken *token = [[WSSEUsernameToken alloc] initWithUsername:@"u" password:@"p"];
    NSError *err = nil;
    NSString *env = [SOAPEnvelope wrapBody:@"<Foo/>"
                                  headers:@[token]
                                  version:SOAPVersionV1_1
                                    error:&err];
    XCTAssertNil(err);
    XCTAssertTrue([env containsString:@"<soap:Header><wsse:Security"]);
    XCTAssertTrue([env containsString:@"</soap:Header><soap:Body><Foo/></soap:Body>"]);
}

- (void)testWSSEUsernameTokenStructure {
    WSSEUsernameToken *t = [[WSSEUsernameToken alloc] initWithUsername:@"admin" password:@"a&b<\""];
    NSError *err = nil;
    NSString *xml = [t encodeSOAPHeader:&err];
    XCTAssertNil(err);
    XCTAssertTrue([xml containsString:@"<wsse:Username>admin</wsse:Username>"]);
    // Password content must be XML-escaped.
    XCTAssertTrue([xml containsString:@"<wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">a&amp;b&lt;&quot;</wsse:Password>"]);
}

- (void)testSOAPVersionContentTypes {
    XCTAssertEqualObjects(SOAPVersionContentType(SOAPVersionV1_1), @"text/xml; charset=utf-8");
    XCTAssertEqualObjects(SOAPVersionContentType(SOAPVersionV1_2), @"application/soap+xml; charset=utf-8");
}

- (void)testFixedHeaderProvider {
    WSSEUsernameToken *t = [[WSSEUsernameToken alloc] initWithUsername:@"u" password:@"p"];
    SOAPFixedHeaderProvider *provider = [[SOAPFixedHeaderProvider alloc] initWithHeaders:@[t]];
    NSArray *headers = [provider headersForSOAPAction:@"anything"];
    XCTAssertEqual(headers.count, 1);
}

@end
