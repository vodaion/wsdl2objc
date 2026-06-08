// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:SessionEcho

import Foundation
import SOAPMacros

@SOAPType(namespace: "urn:SessionEcho", name: "SessionHeader")
public struct SessionHeader {
    @SOAPElement(name: "token")
    public var token: String

    public init(token: String) {
        self.token = token
    }
}

@SOAPType(namespace: "urn:SessionEcho", name: "EchoRequest")
public struct EchoRequest {
    @SOAPElement(name: "text")
    public var text: String

    public init(text: String) {
        self.text = text
    }
}

@SOAPType(namespace: "urn:SessionEcho", name: "EchoResponse")
public struct EchoResponse {
    @SOAPElement(name: "text")
    public var text: String

    public init(text: String) {
        self.text = text
    }
}

@SOAPService(endpoint: "https://example.com/Echo", soapVersion: .v1_1)
public actor SessionEchoService {
    @SOAPOperation(name: "Echo", soapAction: "urn:SessionEcho/Echo", headerParams: ["sessionHeader"], bodyWireNames: ["EchoRequest"], bodyNamespace: "urn:SessionEcho")
    public func echo(parameters: EchoRequest, sessionHeader: SessionHeader) async throws -> EchoResponse
}

extension SessionHeader: SOAPHeader {}
