// Live demo that exercises array decoding against the public CountryInfo
// SOAP service at webservices.oorsprong.org. The arrays-track validation:
// ListOfContinentsByName returns ArrayOftContinent { tContinent: [TContinent] }
// which round-trips through the macro-synthesized SOAPCodable impl.

import Foundation
import SOAPMacros

@main
struct Demo {
    static func main() async {
        let service = CountryInfoService()
        do {
            let continents = try await service.listOfContinentsByName(
                parameters: ListOfContinentsByName()
            )
            print("Continents:")
            for c in continents.listOfContinentsByNameResult.tContinent {
                print("  \(c.sCode)  \(c.sName)")
            }
        } catch let fault as SOAPFault {
            print("SOAP fault \(fault.code): \(fault.reason)")
        } catch {
            print("Transport error: \(error)")
        }
    }
}
