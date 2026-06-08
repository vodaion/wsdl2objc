// Encode/decode roundtrip through `SOAPModel`'s runtime-reflection codec.
// Mirrors the kinds of types the emitter generates.

#import <XCTest/XCTest.h>
@import SOAPObjCRuntime;

#pragma mark - Fixture types

@interface SOAPModelTestsPerson : SOAPModel
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *age;
@property (nonatomic, strong, nullable) NSDecimalNumber *balance;
@property (nonatomic, strong, nullable) NSDate *bornOn;
@end

@implementation SOAPModelTestsPerson
SOAP_TYPE_BEGIN(@"urn:demo", @"Person")
    SOAP_ELEMENT(name, @"name"),
    SOAP_ELEMENT(age, @"age"),
    SOAP_ELEMENT(balance, @"balance"),
    SOAP_ELEMENT(bornOn, @"bornOn")
SOAP_TYPE_END
@end

@interface SOAPModelTestsItem : SOAPModel
@property (nonatomic, strong, nullable) NSString *itemId;     // attribute
@property (nonatomic, strong, nullable) NSString *label;
@end

@implementation SOAPModelTestsItem
SOAP_TYPE_BEGIN(@"urn:demo", @"Item")
    SOAP_ATTRIBUTE(itemId, @"id"),
    SOAP_ELEMENT(label, @"label")
SOAP_TYPE_END
@end

@interface SOAPModelTestsBasket : SOAPModel
@property (nonatomic, strong, nullable) NSString *owner;
@property (nonatomic, strong, nullable) NSArray<SOAPModelTestsItem *> *items;
@end

@implementation SOAPModelTestsBasket
SOAP_TYPE_BEGIN(@"urn:demo", @"Basket")
    SOAP_ELEMENT(owner, @"owner"),
    SOAP_ELEMENT_ARRAY(items, @"item", SOAPModelTestsItem)
SOAP_TYPE_END
@end

#pragma mark - Tests

@interface SOAPModelTests : XCTestCase
@end

@implementation SOAPModelTests

- (void)testEncodesPrimitivesAndInjectsNamespace {
    SOAPModelTestsPerson *p = [SOAPModelTestsPerson new];
    p.name = @"Alice";
    p.age = @42;
    p.balance = [NSDecimalNumber decimalNumberWithString:@"123.45"];

    NSError *err = nil;
    NSString *xml = [p encodeSOAPBody:&err];
    XCTAssertNil(err);
    XCTAssertTrue([xml hasPrefix:@"<Person xmlns=\"urn:demo\""]);
    XCTAssertTrue([xml containsString:@"<name>Alice</name>"]);
    XCTAssertTrue([xml containsString:@"<age>42</age>"]);
    XCTAssertTrue([xml containsString:@"<balance>123.45</balance>"]);
    XCTAssertTrue([xml hasSuffix:@"</Person>"]);
}

- (void)testEncodeSkipsNilProperties {
    SOAPModelTestsPerson *p = [SOAPModelTestsPerson new];
    p.name = @"Bob";  // only name set
    NSString *xml = [p encodeSOAPBody:NULL];
    XCTAssertTrue([xml containsString:@"<name>Bob</name>"]);
    XCTAssertFalse([xml containsString:@"<age>"]);
    XCTAssertFalse([xml containsString:@"<balance>"]);
}

- (void)testEncodeRootNameOverride {
    // Multi-part body: the wire element name differs from the type's _soapName.
    SOAPModelTestsPerson *p = [SOAPModelTestsPerson new];
    p.name = @"Carol";
    NSString *xml = [p encodeSOAPBodyWithRootName:@"Author" error:NULL];
    XCTAssertTrue([xml hasPrefix:@"<Author xmlns=\"urn:demo\""]);
    XCTAssertTrue([xml hasSuffix:@"</Author>"]);
}

- (void)testAttributesRenderAsXmlAttributes {
    SOAPModelTestsItem *item = [SOAPModelTestsItem new];
    item.itemId = @"42";
    item.label = @"foo";
    NSString *xml = [item encodeSOAPBody:NULL];
    XCTAssertTrue([xml containsString:@" id=\"42\""]);
    XCTAssertTrue([xml containsString:@"<label>foo</label>"]);
}

- (void)testArrayElementsRoundTrip {
    SOAPModelTestsItem *a = [SOAPModelTestsItem new]; a.itemId = @"1"; a.label = @"foo";
    SOAPModelTestsItem *b = [SOAPModelTestsItem new]; b.itemId = @"2"; b.label = @"bar";
    SOAPModelTestsBasket *basket = [SOAPModelTestsBasket new];
    basket.owner = @"Eve";
    basket.items = @[a, b];

    NSError *err = nil;
    NSString *xml = [basket encodeSOAPBody:&err];
    XCTAssertNil(err);
    // Two repeated <item> elements with id-attribute and inner <label>.
    XCTAssertTrue([xml containsString:@"<item"]);
    XCTAssertTrue([xml containsString:@"id=\"1\""]);
    XCTAssertTrue([xml containsString:@"id=\"2\""]);
    XCTAssertTrue([xml containsString:@"<label>foo</label>"]);
    XCTAssertTrue([xml containsString:@"<label>bar</label>"]);
}

- (void)testDecodeFromXMLNode {
    NSString *raw =
        @"<Person>"
         "<name>Dora</name>"
         "<age>30</age>"
         "<balance>9.99</balance>"
         "<bornOn>1995-04-12</bornOn>"
         "</Person>";
    SOAPXMLNode *node = [SOAPXMLNode parseData:[raw dataUsingEncoding:NSUTF8StringEncoding] error:NULL];
    XCTAssertNotNil(node);

    NSError *err = nil;
    SOAPModelTestsPerson *p = [SOAPModelTestsPerson decodeFromSOAPElement:node error:&err];
    XCTAssertNil(err);
    XCTAssertEqualObjects(p.name, @"Dora");
    XCTAssertEqualObjects(p.age, @30);
    XCTAssertEqualObjects(p.balance, [NSDecimalNumber decimalNumberWithString:@"9.99"]);
    XCTAssertNotNil(p.bornOn);
}

- (void)testDecodeArrayFromXMLNode {
    NSString *raw =
        @"<Basket>"
         "<owner>Frank</owner>"
         "<item id=\"1\"><label>foo</label></item>"
         "<item id=\"2\"><label>bar</label></item>"
         "<item id=\"3\"><label>baz</label></item>"
         "</Basket>";
    SOAPXMLNode *node = [SOAPXMLNode parseData:[raw dataUsingEncoding:NSUTF8StringEncoding] error:NULL];
    NSError *err = nil;
    SOAPModelTestsBasket *basket = [SOAPModelTestsBasket decodeFromSOAPElement:node error:&err];
    XCTAssertNil(err);
    XCTAssertEqualObjects(basket.owner, @"Frank");
    XCTAssertEqual(basket.items.count, 3);
    XCTAssertEqualObjects(basket.items[0].itemId, @"1");
    XCTAssertEqualObjects(basket.items[1].label, @"bar");
    XCTAssertEqualObjects(basket.items[2].itemId, @"3");
}

- (void)testDecodeResponseStripsEnvelope {
    NSString *envelope =
        @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
         "<soap:Body><Person><name>Grace</name></Person></soap:Body></soap:Envelope>";
    NSError *err = nil;
    SOAPModelTestsPerson *p = [SOAPModelTestsPerson decodeSOAPResponse:[envelope dataUsingEncoding:NSUTF8StringEncoding]
                                                          operationName:@"AnyOp"
                                                                  error:&err];
    XCTAssertNil(err);
    XCTAssertEqualObjects(p.name, @"Grace");
}

- (void)testDecodeSOAPFaultSurfacesAsError {
    NSString *envelope =
        @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
         "<soap:Body><soap:Fault>"
         "<faultcode>Client</faultcode>"
         "<faultstring>bad input</faultstring>"
         "</soap:Fault></soap:Body></soap:Envelope>";
    NSError *err = nil;
    SOAPModelTestsPerson *p = [SOAPModelTestsPerson decodeSOAPResponse:[envelope dataUsingEncoding:NSUTF8StringEncoding]
                                                          operationName:@"AnyOp"
                                                                  error:&err];
    XCTAssertNil(p);
    XCTAssertNotNil(err);
    XCTAssertEqualObjects(err.domain, SOAPErrorDomain);
    XCTAssertEqual(err.code, SOAPErrorCodeFault);
    SOAPFault *fault = err.userInfo[SOAPFaultKey];
    XCTAssertEqualObjects(fault.code, @"Client");
    XCTAssertEqualObjects(fault.reason, @"bad input");
}

@end
