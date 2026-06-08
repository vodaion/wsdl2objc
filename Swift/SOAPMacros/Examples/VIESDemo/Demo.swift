// Live demo: EU VIES VAT validator.
// Exercises xs:date decoding — the response carries
//   <requestDate>2026-06-05+02:00</requestDate>
// which is xs:date with timezone offset (not xs:dateTime).

import Foundation
import SOAPMacros

@main
struct Demo {
    static func main() async {
        let service = CheckVatService()
        do {
            let response = try await service.checkVat(
                parameters: CheckVat(countryCode: "BE", vatNumber: "0203049995")
            )
            print("country:      \(response.countryCode)")
            print("vatNumber:    \(response.vatNumber)")
            print("requestDate:  \(response.requestDate)")
            print("valid:        \(response.valid)")
            print("name:         \(response.name)")
        } catch let fault as SOAPFault {
            print("SOAP fault \(fault.code): \(fault.reason)")
        } catch {
            print("Transport error: \(error)")
        }
    }
}
