import Foundation
import SOAPMacros

@main
struct Demo {
    static func main() async {
        let service = TemperatureConversionsService()
        do {
            let response = try await service.celsiusToFahrenheit(
                input: CelsiusToFahrenheit(nCelsius: Decimal(100))
            )
            print("100°C = \(response.celsiusToFahrenheitResult)°F")
            
            let response2 = try await service.fahrenheitToCelsius(
                input: FahrenheitToCelsius(nFahrenheit: Decimal(100))
            )
            print("100°F = \(response2.fahrenheitToCelsiusResult)°C")
        } catch let fault as SOAPFault {
            print("SOAP fault \(fault.code): \(fault.reason)")
        } catch {
            print("Transport error: \(error)")
        }
    }
}
