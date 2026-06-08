import XCTest
@testable import SOAPRuntime

final class SOAPBodyPartTests: XCTestCase {
    func testPrimitiveBodyPartRendersWithNamespace() throws {
        let xml = try "buyer"._encodeSOAPBodyPart(named: "partnerLink", namespace: "http://www.yoerg.net")
        XCTAssertEqual(xml, "<partnerLink xmlns=\"http://www.yoerg.net\">buyer</partnerLink>")
    }

    func testPrimitiveBodyPartEscapesSpecialChars() throws {
        let xml = try "a & b < c"._encodeSOAPBodyPart(named: "x", namespace: nil)
        XCTAssertEqual(xml, "<x>a &amp; b &lt; c</x>")
    }

    func testIntBodyPartRenders() throws {
        let xml = try Int(42)._encodeSOAPBodyPart(named: "n", namespace: nil)
        XCTAssertEqual(xml, "<n>42</n>")
    }

    func testDoubleBodyPartRenders() throws {
        let xml = try Double(9.99)._encodeSOAPBodyPart(named: "price", namespace: nil)
        XCTAssertEqual(xml, "<price>9.99</price>")
    }

    func testSOAPCodableBodyPartUsesProvidedRootName() throws {
        // The emitter passes the WSDL element name (`sendPurchaseOrder`) even
        // though the underlying type is named `sendPORequest`.
        struct SendPORequest: SOAPCodable {
            static let _soapNamespace = "http://www.yoerg.net"
            static let _soapName = "sendPORequest"
            let customerId: Int
        }
        let req = SendPORequest(customerId: 7)
        let xml = try req._encodeSOAPBodyPart(named: "sendPurchaseOrder", namespace: nil)
        XCTAssertTrue(xml.hasPrefix("<sendPurchaseOrder xmlns=\"http://www.yoerg.net\""), "got: \(xml)")
        XCTAssertTrue(xml.contains("<customerId>7</customerId>"))
        XCTAssertTrue(xml.hasSuffix("</sendPurchaseOrder>"))
    }

    func testMixedMultipartBodyConcatenates() throws {
        struct SendPORequest: SOAPCodable {
            static let _soapNamespace = "http://www.yoerg.net"
            static let _soapName = "sendPORequest"
            let quantity: Int
        }
        let p1 = try SendPORequest(quantity: 2)
            ._encodeSOAPBodyPart(named: "sendPurchaseOrder", namespace: nil)
        let p2 = try "purchaseOrderPortType"
            ._encodeSOAPBodyPart(named: "portType", namespace: "http://www.yoerg.net")
        let payload = p1 + p2
        let envelope = try SOAPEnvelope.wrap(body: payload, headers: [], version: .v1_1)
        XCTAssertTrue(envelope.contains("<sendPurchaseOrder"))
        XCTAssertTrue(envelope.contains("<quantity>2</quantity>"))
        XCTAssertTrue(envelope.contains("</sendPurchaseOrder>"))
        XCTAssertTrue(envelope.contains("<portType xmlns=\"http://www.yoerg.net\">purchaseOrderPortType</portType>"))
        // sendPurchaseOrder appears before portType
        if let r1 = envelope.range(of: "<sendPurchaseOrder"),
           let r2 = envelope.range(of: "<portType") {
            XCTAssertLessThan(r1.lowerBound, r2.lowerBound)
        } else {
            XCTFail("expected both body parts to be present")
        }
    }
}
