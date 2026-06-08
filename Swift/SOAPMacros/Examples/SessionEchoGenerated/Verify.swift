// Compile-only verification that the wsdl2objc Swift emitter produces output
// that compiles against SOAPMacros when the WSDL declares typed SOAP headers.
// SessionEcho.swift is a verbatim copy of `make swift-session` output,
// refreshed by `make swift-verify` from the repo root.

import Foundation
import SOAPMacros

@main
struct VerifyGenerated {
    static func main() async throws {
        let service = SessionEchoService()
        // The header param is typed; the call site sees it as a regular
        // labeled argument. The macro-generated body wraps it into the
        // `<soap:Header>` block automatically.
        let _: EchoResponse = try await service.echo(
            parameters: EchoRequest(text: "hi"),
            sessionHeader: SessionHeader(token: "tok-123")
        )
    }
}
