// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://webservices.daehosting.com/temperature

import Foundation
import SOAPMacros

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "CelsiusToFahrenheit")
public struct CelsiusToFahrenheit {
    @SOAPElement(name: "nCelsius")
    public var nCelsius: Decimal

    public init(nCelsius: Decimal) {
        self.nCelsius = nCelsius
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "CelsiusToFahrenheitResponse")
public struct CelsiusToFahrenheitResponse {
    @SOAPElement(name: "CelsiusToFahrenheitResult")
    public var celsiusToFahrenheitResult: Decimal

    public init(celsiusToFahrenheitResult: Decimal) {
        self.celsiusToFahrenheitResult = celsiusToFahrenheitResult
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "FahrenheitToCelsius")
public struct FahrenheitToCelsius {
    @SOAPElement(name: "nFahrenheit")
    public var nFahrenheit: Decimal

    public init(nFahrenheit: Decimal) {
        self.nFahrenheit = nFahrenheit
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "FahrenheitToCelsiusResponse")
public struct FahrenheitToCelsiusResponse {
    @SOAPElement(name: "FahrenheitToCelsiusResult")
    public var fahrenheitToCelsiusResult: Decimal

    public init(fahrenheitToCelsiusResult: Decimal) {
        self.fahrenheitToCelsiusResult = fahrenheitToCelsiusResult
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "WindChillInCelsius")
public struct WindChillInCelsius {
    @SOAPElement(name: "nCelsius")
    public var nCelsius: Decimal

    @SOAPElement(name: "nWindSpeed")
    public var nWindSpeed: Decimal

    public init(nCelsius: Decimal, nWindSpeed: Decimal) {
        self.nCelsius = nCelsius
        self.nWindSpeed = nWindSpeed
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "WindChillInCelsiusResponse")
public struct WindChillInCelsiusResponse {
    @SOAPElement(name: "WindChillInCelsiusResult")
    public var windChillInCelsiusResult: Decimal

    public init(windChillInCelsiusResult: Decimal) {
        self.windChillInCelsiusResult = windChillInCelsiusResult
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "WindChillInFahrenheit")
public struct WindChillInFahrenheit {
    @SOAPElement(name: "nFahrenheit")
    public var nFahrenheit: Decimal

    @SOAPElement(name: "nWindSpeed")
    public var nWindSpeed: Decimal

    public init(nFahrenheit: Decimal, nWindSpeed: Decimal) {
        self.nFahrenheit = nFahrenheit
        self.nWindSpeed = nWindSpeed
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "WindChillInFahrenheitResponse")
public struct WindChillInFahrenheitResponse {
    @SOAPElement(name: "WindChillInFahrenheitResult")
    public var windChillInFahrenheitResult: Decimal

    public init(windChillInFahrenheitResult: Decimal) {
        self.windChillInFahrenheitResult = windChillInFahrenheitResult
    }
}

@SOAPService(endpoint: "http://webservices.daehosting.com/services/TemperatureConversions.wso", soapVersion: .v1_1)
public actor TemperatureConversionsService {
    @SOAPOperation(name: "CelsiusToFahrenheit", soapAction: "", bodyWireNames: ["CelsiusToFahrenheit"], bodyNamespace: "http://webservices.daehosting.com/temperature")
    public func celsiusToFahrenheit(parameters: CelsiusToFahrenheit) async throws -> CelsiusToFahrenheitResponse

    @SOAPOperation(name: "FahrenheitToCelsius", soapAction: "", bodyWireNames: ["FahrenheitToCelsius"], bodyNamespace: "http://webservices.daehosting.com/temperature")
    public func fahrenheitToCelsius(parameters: FahrenheitToCelsius) async throws -> FahrenheitToCelsiusResponse

    @SOAPOperation(name: "WindChillInCelsius", soapAction: "", bodyWireNames: ["WindChillInCelsius"], bodyNamespace: "http://webservices.daehosting.com/temperature")
    public func windChillInCelsius(parameters: WindChillInCelsius) async throws -> WindChillInCelsiusResponse

    @SOAPOperation(name: "WindChillInFahrenheit", soapAction: "", bodyWireNames: ["WindChillInFahrenheit"], bodyNamespace: "http://webservices.daehosting.com/temperature")
    public func windChillInFahrenheit(parameters: WindChillInFahrenheit) async throws -> WindChillInFahrenheitResponse
}
