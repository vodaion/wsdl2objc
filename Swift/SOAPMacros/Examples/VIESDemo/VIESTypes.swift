// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:ec.europa.eu:taxud:vies:services:checkVat:types

import Foundation
import SOAPMacros

@SOAPType(namespace: "urn:ec.europa.eu:taxud:vies:services:checkVat:types", name: "checkVat")
public struct CheckVat {
    @SOAPElement(name: "countryCode")
    public var countryCode: String

    @SOAPElement(name: "vatNumber")
    public var vatNumber: String

    public init(countryCode: String, vatNumber: String) {
        self.countryCode = countryCode
        self.vatNumber = vatNumber
    }
}

@SOAPType(namespace: "urn:ec.europa.eu:taxud:vies:services:checkVat:types", name: "checkVatResponse")
public struct CheckVatResponse {
    @SOAPElement(name: "countryCode")
    public var countryCode: String

    @SOAPElement(name: "vatNumber")
    public var vatNumber: String

    @SOAPElement(name: "requestDate")
    public var requestDate: Date

    @SOAPElement(name: "valid")
    public var valid: Bool

    @SOAPElement(name: "name")
    public var name: String

    @SOAPElement(name: "address")
    public var address: String

    public init(countryCode: String, vatNumber: String, requestDate: Date, valid: Bool, name: String, address: String) {
        self.countryCode = countryCode
        self.vatNumber = vatNumber
        self.requestDate = requestDate
        self.valid = valid
        self.name = name
        self.address = address
    }
}

@SOAPType(namespace: "urn:ec.europa.eu:taxud:vies:services:checkVat:types", name: "checkVatApprox")
public struct CheckVatApprox {
    @SOAPElement(name: "countryCode")
    public var countryCode: String

    @SOAPElement(name: "vatNumber")
    public var vatNumber: String

    @SOAPElement(name: "traderName")
    public var traderName: String

    @SOAPElement(name: "traderCompanyType")
    public var traderCompanyType: String

    @SOAPElement(name: "traderStreet")
    public var traderStreet: String

    @SOAPElement(name: "traderPostcode")
    public var traderPostcode: String

    @SOAPElement(name: "traderCity")
    public var traderCity: String

    @SOAPElement(name: "requesterCountryCode")
    public var requesterCountryCode: String

    @SOAPElement(name: "requesterVatNumber")
    public var requesterVatNumber: String

    public init(countryCode: String, vatNumber: String, traderName: String, traderCompanyType: String, traderStreet: String, traderPostcode: String, traderCity: String, requesterCountryCode: String, requesterVatNumber: String) {
        self.countryCode = countryCode
        self.vatNumber = vatNumber
        self.traderName = traderName
        self.traderCompanyType = traderCompanyType
        self.traderStreet = traderStreet
        self.traderPostcode = traderPostcode
        self.traderCity = traderCity
        self.requesterCountryCode = requesterCountryCode
        self.requesterVatNumber = requesterVatNumber
    }
}

public typealias CompanyTypeCode = String

@SOAPType(namespace: "urn:ec.europa.eu:taxud:vies:services:checkVat:types", name: "checkVatApproxResponse")
public struct CheckVatApproxResponse {
    @SOAPElement(name: "countryCode")
    public var countryCode: String

    @SOAPElement(name: "vatNumber")
    public var vatNumber: String

    @SOAPElement(name: "requestDate")
    public var requestDate: Date

    @SOAPElement(name: "valid")
    public var valid: Bool

    @SOAPElement(name: "traderName")
    public var traderName: String

    @SOAPElement(name: "traderCompanyType")
    public var traderCompanyType: String

    @SOAPElement(name: "traderAddress")
    public var traderAddress: String

    @SOAPElement(name: "traderStreet")
    public var traderStreet: String

    @SOAPElement(name: "traderPostcode")
    public var traderPostcode: String

    @SOAPElement(name: "traderCity")
    public var traderCity: String

    @SOAPElement(name: "traderNameMatch")
    public var traderNameMatch: MatchCode

    @SOAPElement(name: "traderCompanyTypeMatch")
    public var traderCompanyTypeMatch: MatchCode

    @SOAPElement(name: "traderStreetMatch")
    public var traderStreetMatch: MatchCode

    @SOAPElement(name: "traderPostcodeMatch")
    public var traderPostcodeMatch: MatchCode

    @SOAPElement(name: "traderCityMatch")
    public var traderCityMatch: MatchCode

    @SOAPElement(name: "requestIdentifier")
    public var requestIdentifier: String

    public init(countryCode: String, vatNumber: String, requestDate: Date, valid: Bool, traderName: String, traderCompanyType: String, traderAddress: String, traderStreet: String, traderPostcode: String, traderCity: String, traderNameMatch: MatchCode, traderCompanyTypeMatch: MatchCode, traderStreetMatch: MatchCode, traderPostcodeMatch: MatchCode, traderCityMatch: MatchCode, requestIdentifier: String) {
        self.countryCode = countryCode
        self.vatNumber = vatNumber
        self.requestDate = requestDate
        self.valid = valid
        self.traderName = traderName
        self.traderCompanyType = traderCompanyType
        self.traderAddress = traderAddress
        self.traderStreet = traderStreet
        self.traderPostcode = traderPostcode
        self.traderCity = traderCity
        self.traderNameMatch = traderNameMatch
        self.traderCompanyTypeMatch = traderCompanyTypeMatch
        self.traderStreetMatch = traderStreetMatch
        self.traderPostcodeMatch = traderPostcodeMatch
        self.traderCityMatch = traderCityMatch
        self.requestIdentifier = requestIdentifier
    }
}

public enum MatchCode: String, Codable, Sendable {
    case _1 = "1"
    case _2 = "2"
    case _3 = "3"
}
