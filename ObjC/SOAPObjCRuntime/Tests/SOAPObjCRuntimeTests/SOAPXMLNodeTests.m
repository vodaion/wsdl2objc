#import <XCTest/XCTest.h>
@import SOAPObjCRuntime;

@interface SOAPXMLNodeTests : XCTestCase
@end

@implementation SOAPXMLNodeTests

- (SOAPXMLNode *)parseString:(NSString *)xml {
    NSError *error = nil;
    SOAPXMLNode *node = [SOAPXMLNode parseData:[xml dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(node);
    return node;
}

- (void)testParseFlatElement {
    SOAPXMLNode *n = [self parseString:@"<root><a>x</a><b>y</b></root>"];
    XCTAssertEqualObjects(n.localName, @"root");
    XCTAssertEqual(n.children.count, 2);
    XCTAssertEqualObjects([n firstChildNamed:@"a"].stringValue, @"x");
    XCTAssertEqualObjects([n firstChildNamed:@"b"].stringValue, @"y");
}

- (void)testFindsRepeatedChildren {
    SOAPXMLNode *n = [self parseString:@"<root><item>1</item><item>2</item><item>3</item></root>"];
    NSArray<SOAPXMLNode *> *items = [n childrenNamed:@"item"];
    XCTAssertEqual(items.count, 3);
    XCTAssertEqualObjects(items[0].stringValue, @"1");
    XCTAssertEqualObjects(items[2].stringValue, @"3");
}

- (void)testParseAttributes {
    SOAPXMLNode *n = [self parseString:@"<root id=\"42\" name=\"foo\"/>"];
    XCTAssertEqualObjects(n.attributes[@"id"], @"42");
    XCTAssertEqualObjects(n.attributes[@"name"], @"foo");
}

- (void)testNamespaceProcessingStripsPrefix {
    // shouldProcessNamespaces=YES → `localName` is the unprefixed tag.
    SOAPXMLNode *n = [self parseString:@"<m:root xmlns:m=\"urn:demo\"><m:child>hi</m:child></m:root>"];
    XCTAssertEqualObjects(n.localName, @"root");
    XCTAssertEqualObjects([n firstChildNamed:@"child"].stringValue, @"hi");
}

- (void)testSerializeRoundTrip {
    SOAPXMLNode *n = [self parseString:@"<root id=\"42\"><a>x</a><a>y</a></root>"];
    NSString *out = [n serialize];
    // Attribute order is alphabetized; children preserve doc order.
    XCTAssertTrue([out containsString:@"id=\"42\""]);
    XCTAssertTrue([out containsString:@"<a>x</a><a>y</a>"]);
}

- (void)testSerializeEscapesContent {
    SOAPXMLNode *n = [[SOAPXMLNode alloc] initWithLocalName:@"v"
                                                namespaceURI:nil
                                                  attributes:@{}
                                                    children:@[]
                                                 stringValue:@"a & b < c"];
    XCTAssertEqualObjects([n serialize], @"<v>a &amp; b &lt; c</v>");
}

- (void)testParseBodyExtractsSoapBody {
    NSString *envelope =
        @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
         "<soap:Body><Hello>world</Hello></soap:Body></soap:Envelope>";
    NSError *err = nil;
    SOAPXMLNode *body = [SOAPXMLNode parseBodyFromData:[envelope dataUsingEncoding:NSUTF8StringEncoding]
                                                 error:&err];
    XCTAssertNil(err);
    XCTAssertEqualObjects(body.localName, @"Body");
    XCTAssertEqualObjects([body firstChildNamed:@"Hello"].stringValue, @"world");
}

@end
