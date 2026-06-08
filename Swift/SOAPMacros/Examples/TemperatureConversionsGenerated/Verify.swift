// Build-time verification that the wsdl2objc Swift emitter produces output
// that compiles against SOAPMacros. The TemperatureConversions.swift file
// in this directory is a verbatim copy of `make swift-temp` output and is
// overwritten by `make swift-verify` from the repo root.

import Foundation
import SOAPMacros

@main
struct VerifyGenerated {
    static func main() async throws {
        let service = TemperatureConversionsService()
        let _: CelsiusToFahrenheitResponse = try await service.celsiusToFahrenheit(
            parameters: CelsiusToFahrenheit(nCelsius: Decimal(0))
        )
    }
}
