// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:ec.europa.eu:taxud:vies:services:checkVat

import Foundation
import SOAPMacros

@SOAPService(endpoint: "http://ec.europa.eu/taxation_customs/vies/services/checkVatService", soapVersion: .v1_1)
public actor CheckVatService {
    @SOAPOperation(name: "checkVat", soapAction: "", bodyWireNames: ["checkVat"], bodyNamespace: "urn:ec.europa.eu:taxud:vies:services:checkVat:types")
    public func checkVat(parameters: CheckVat) async throws -> CheckVatResponse

    @SOAPOperation(name: "checkVatApprox", soapAction: "", bodyWireNames: ["checkVatApprox"], bodyNamespace: "urn:ec.europa.eu:taxud:vies:services:checkVat:types")
    public func checkVatApprox(parameters: CheckVatApprox) async throws -> CheckVatApproxResponse
}
