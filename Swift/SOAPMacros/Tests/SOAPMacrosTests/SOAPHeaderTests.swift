import XCTest
@testable import SOAPRuntime

final class SOAPHeaderTests: XCTestCase {
    func testWSSEUsernameTokenStructure() throws {
        let header = WSSEUsernameToken(username: "admin", password: "secret&<>\"")
        let xml = try header._encodeSOAPHeader()
        XCTAssertTrue(xml.contains("<wsse:Security"))
        XCTAssertTrue(xml.contains("<wsse:UsernameToken>"))
        XCTAssertTrue(xml.contains("<wsse:Username>admin</wsse:Username>"))
        // password content must be XML-escaped
        XCTAssertTrue(xml.contains("<wsse:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">secret&amp;&lt;&gt;&quot;</wsse:Password>"))
    }

    func testEnvelopeWithoutHeadersOmitsHeaderBlock() throws {
        let env = try SOAPEnvelope.wrap(body: "<Foo/>", headers: [], version: .v1_1)
        XCTAssertFalse(env.contains("<soap:Header"))
        XCTAssertTrue(env.contains("<soap:Body><Foo/></soap:Body>"))
    }

    func testEnvelopeWithHeadersWrapsHeaderBlock() throws {
        let header = WSSEUsernameToken(username: "u", password: "p")
        let env = try SOAPEnvelope.wrap(body: "<Foo/>", headers: [header], version: .v1_1)
        XCTAssertTrue(env.contains("<soap:Header><wsse:Security"))
        XCTAssertTrue(env.contains("</soap:Header><soap:Body><Foo/></soap:Body>"))
    }

    func testFixedHeaderProviderReturnsHeaders() async throws {
        let provider = FixedHeaderProvider([WSSEUsernameToken(username: "u", password: "p")])
        let headers = try await provider.headers(forSoapAction: "anything")
        XCTAssertEqual(headers.count, 1)
    }

    func testSOAPCodableCanAdoptSOAPHeaderByDefault() throws {
        // Custom typed header via SOAPCodable + bare conformance — exactly what
        // the emitter emits for a WSDL-declared header type:
        //     extension SessionHeader: SOAPHeader {}
        struct CustomHeader: SOAPCodable, SOAPHeader {
            static let _soapNamespace = "urn:demo"
            static let _soapName = "TraceId"
            let value: String
        }
        let xml = try CustomHeader(value: "abc-123")._encodeSOAPHeader()
        XCTAssertTrue(xml.contains("<TraceId"))
        XCTAssertTrue(xml.contains("xmlns=\"urn:demo\""))
        XCTAssertTrue(xml.contains("<value>abc-123</value>"))
    }

    func testTypedHeaderRendersInsideSoapHeader() throws {
        // Real round-trip through XMLCoder: a SOAPCodable struct that also
        // conforms to SOAPHeader is wrapped by SOAPEnvelope into the
        // <soap:Header> block.
        struct SessionHeader: SOAPCodable, SOAPHeader {
            static let _soapNamespace = "urn:SessionEcho"
            static let _soapName = "SessionHeader"
            let token: String
        }

        let env = try SOAPEnvelope.wrap(
            body: "<EchoRequest/>",
            headers: [SessionHeader(token: "tok-xyz")],
            version: .v1_1
        )
        XCTAssertTrue(env.contains("<soap:Header>"))
        XCTAssertTrue(env.contains("xmlns=\"urn:SessionEcho\""))
        XCTAssertTrue(env.contains("<token>tok-xyz</token>"))
        XCTAssertTrue(env.contains("</soap:Header><soap:Body><EchoRequest/></soap:Body>"))
    }
}
