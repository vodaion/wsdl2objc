// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://www.oorsprong.org/websamples.countryinfo

import Foundation
import SOAPMacros

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "tContinent")
public struct TContinent {
    @SOAPElement(name: "sCode")
    public var sCode: String

    @SOAPElement(name: "sName")
    public var sName: String

    public init(sCode: String, sName: String) {
        self.sCode = sCode
        self.sName = sName
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "tCurrency")
public struct TCurrency {
    @SOAPElement(name: "sISOCode")
    public var sISOCode: String

    @SOAPElement(name: "sName")
    public var sName: String

    public init(sISOCode: String, sName: String) {
        self.sISOCode = sISOCode
        self.sName = sName
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "tCountryCodeAndName")
public struct TCountryCodeAndName {
    @SOAPElement(name: "sISOCode")
    public var sISOCode: String

    @SOAPElement(name: "sName")
    public var sName: String

    public init(sISOCode: String, sName: String) {
        self.sISOCode = sISOCode
        self.sName = sName
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "tCountryCodeAndNameGroupedByContinent")
public struct TCountryCodeAndNameGroupedByContinent {
    @SOAPElement(name: "Continent")
    public var continent: TContinent

    @SOAPElement(name: "CountryCodeAndNames")
    public var countryCodeAndNames: ArrayOftCountryCodeAndName

    public init(continent: TContinent, countryCodeAndNames: ArrayOftCountryCodeAndName) {
        self.continent = continent
        self.countryCodeAndNames = countryCodeAndNames
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ArrayOftCountryCodeAndName")
public struct ArrayOftCountryCodeAndName {
    @SOAPElement(name: "tCountryCodeAndName", maxOccurs: -1)
    public var tCountryCodeAndName: [TCountryCodeAndName]

    public init(tCountryCodeAndName: [TCountryCodeAndName] = []) {
        self.tCountryCodeAndName = tCountryCodeAndName
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "tCountryInfo")
public struct TCountryInfo {
    @SOAPElement(name: "sISOCode")
    public var sISOCode: String

    @SOAPElement(name: "sName")
    public var sName: String

    @SOAPElement(name: "sCapitalCity")
    public var sCapitalCity: String

    @SOAPElement(name: "sPhoneCode")
    public var sPhoneCode: String

    @SOAPElement(name: "sContinentCode")
    public var sContinentCode: String

    @SOAPElement(name: "sCurrencyISOCode")
    public var sCurrencyISOCode: String

    @SOAPElement(name: "sCountryFlag")
    public var sCountryFlag: String

    @SOAPElement(name: "Languages")
    public var languages: ArrayOftLanguage

    public init(sISOCode: String, sName: String, sCapitalCity: String, sPhoneCode: String, sContinentCode: String, sCurrencyISOCode: String, sCountryFlag: String, languages: ArrayOftLanguage) {
        self.sISOCode = sISOCode
        self.sName = sName
        self.sCapitalCity = sCapitalCity
        self.sPhoneCode = sPhoneCode
        self.sContinentCode = sContinentCode
        self.sCurrencyISOCode = sCurrencyISOCode
        self.sCountryFlag = sCountryFlag
        self.languages = languages
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ArrayOftLanguage")
public struct ArrayOftLanguage {
    @SOAPElement(name: "tLanguage", maxOccurs: -1)
    public var tLanguage: [TLanguage]

    public init(tLanguage: [TLanguage] = []) {
        self.tLanguage = tLanguage
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "tLanguage")
public struct TLanguage {
    @SOAPElement(name: "sISOCode")
    public var sISOCode: String

    @SOAPElement(name: "sName")
    public var sName: String

    public init(sISOCode: String, sName: String) {
        self.sISOCode = sISOCode
        self.sName = sName
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ArrayOftContinent")
public struct ArrayOftContinent {
    @SOAPElement(name: "tContinent", maxOccurs: -1)
    public var tContinent: [TContinent]

    public init(tContinent: [TContinent] = []) {
        self.tContinent = tContinent
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ArrayOftCurrency")
public struct ArrayOftCurrency {
    @SOAPElement(name: "tCurrency", maxOccurs: -1)
    public var tCurrency: [TCurrency]

    public init(tCurrency: [TCurrency] = []) {
        self.tCurrency = tCurrency
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ArrayOftCountryCodeAndNameGroupedByContinent")
public struct ArrayOftCountryCodeAndNameGroupedByContinent {
    @SOAPElement(name: "tCountryCodeAndNameGroupedByContinent", maxOccurs: -1)
    public var tCountryCodeAndNameGroupedByContinent: [TCountryCodeAndNameGroupedByContinent]

    public init(tCountryCodeAndNameGroupedByContinent: [TCountryCodeAndNameGroupedByContinent] = []) {
        self.tCountryCodeAndNameGroupedByContinent = tCountryCodeAndNameGroupedByContinent
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ArrayOftCountryInfo")
public struct ArrayOftCountryInfo {
    @SOAPElement(name: "tCountryInfo", maxOccurs: -1)
    public var tCountryInfo: [TCountryInfo]

    public init(tCountryInfo: [TCountryInfo] = []) {
        self.tCountryInfo = tCountryInfo
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfContinentsByName")
public struct ListOfContinentsByName {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfContinentsByNameResponse")
public struct ListOfContinentsByNameResponse {
    @SOAPElement(name: "ListOfContinentsByNameResult")
    public var listOfContinentsByNameResult: ArrayOftContinent

    public init(listOfContinentsByNameResult: ArrayOftContinent) {
        self.listOfContinentsByNameResult = listOfContinentsByNameResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfContinentsByCode")
public struct ListOfContinentsByCode {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfContinentsByCodeResponse")
public struct ListOfContinentsByCodeResponse {
    @SOAPElement(name: "ListOfContinentsByCodeResult")
    public var listOfContinentsByCodeResult: ArrayOftContinent

    public init(listOfContinentsByCodeResult: ArrayOftContinent) {
        self.listOfContinentsByCodeResult = listOfContinentsByCodeResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCurrenciesByName")
public struct ListOfCurrenciesByName {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCurrenciesByNameResponse")
public struct ListOfCurrenciesByNameResponse {
    @SOAPElement(name: "ListOfCurrenciesByNameResult")
    public var listOfCurrenciesByNameResult: ArrayOftCurrency

    public init(listOfCurrenciesByNameResult: ArrayOftCurrency) {
        self.listOfCurrenciesByNameResult = listOfCurrenciesByNameResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCurrenciesByCode")
public struct ListOfCurrenciesByCode {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCurrenciesByCodeResponse")
public struct ListOfCurrenciesByCodeResponse {
    @SOAPElement(name: "ListOfCurrenciesByCodeResult")
    public var listOfCurrenciesByCodeResult: ArrayOftCurrency

    public init(listOfCurrenciesByCodeResult: ArrayOftCurrency) {
        self.listOfCurrenciesByCodeResult = listOfCurrenciesByCodeResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CurrencyName")
public struct CurrencyName {
    @SOAPElement(name: "sCurrencyISOCode")
    public var sCurrencyISOCode: String

    public init(sCurrencyISOCode: String) {
        self.sCurrencyISOCode = sCurrencyISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CurrencyNameResponse")
public struct CurrencyNameResponse {
    @SOAPElement(name: "CurrencyNameResult")
    public var currencyNameResult: String

    public init(currencyNameResult: String) {
        self.currencyNameResult = currencyNameResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCountryNamesByCode")
public struct ListOfCountryNamesByCode {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCountryNamesByCodeResponse")
public struct ListOfCountryNamesByCodeResponse {
    @SOAPElement(name: "ListOfCountryNamesByCodeResult")
    public var listOfCountryNamesByCodeResult: ArrayOftCountryCodeAndName

    public init(listOfCountryNamesByCodeResult: ArrayOftCountryCodeAndName) {
        self.listOfCountryNamesByCodeResult = listOfCountryNamesByCodeResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCountryNamesByName")
public struct ListOfCountryNamesByName {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCountryNamesByNameResponse")
public struct ListOfCountryNamesByNameResponse {
    @SOAPElement(name: "ListOfCountryNamesByNameResult")
    public var listOfCountryNamesByNameResult: ArrayOftCountryCodeAndName

    public init(listOfCountryNamesByNameResult: ArrayOftCountryCodeAndName) {
        self.listOfCountryNamesByNameResult = listOfCountryNamesByNameResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCountryNamesGroupedByContinent")
public struct ListOfCountryNamesGroupedByContinent {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfCountryNamesGroupedByContinentResponse")
public struct ListOfCountryNamesGroupedByContinentResponse {
    @SOAPElement(name: "ListOfCountryNamesGroupedByContinentResult")
    public var listOfCountryNamesGroupedByContinentResult: ArrayOftCountryCodeAndNameGroupedByContinent

    public init(listOfCountryNamesGroupedByContinentResult: ArrayOftCountryCodeAndNameGroupedByContinent) {
        self.listOfCountryNamesGroupedByContinentResult = listOfCountryNamesGroupedByContinentResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryName")
public struct CountryName {
    @SOAPElement(name: "sCountryISOCode")
    public var sCountryISOCode: String

    public init(sCountryISOCode: String) {
        self.sCountryISOCode = sCountryISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryNameResponse")
public struct CountryNameResponse {
    @SOAPElement(name: "CountryNameResult")
    public var countryNameResult: String

    public init(countryNameResult: String) {
        self.countryNameResult = countryNameResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryISOCode")
public struct CountryISOCode {
    @SOAPElement(name: "sCountryName")
    public var sCountryName: String

    public init(sCountryName: String) {
        self.sCountryName = sCountryName
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryISOCodeResponse")
public struct CountryISOCodeResponse {
    @SOAPElement(name: "CountryISOCodeResult")
    public var countryISOCodeResult: String

    public init(countryISOCodeResult: String) {
        self.countryISOCodeResult = countryISOCodeResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CapitalCity")
public struct CapitalCity {
    @SOAPElement(name: "sCountryISOCode")
    public var sCountryISOCode: String

    public init(sCountryISOCode: String) {
        self.sCountryISOCode = sCountryISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CapitalCityResponse")
public struct CapitalCityResponse {
    @SOAPElement(name: "CapitalCityResult")
    public var capitalCityResult: String

    public init(capitalCityResult: String) {
        self.capitalCityResult = capitalCityResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryCurrency")
public struct CountryCurrency {
    @SOAPElement(name: "sCountryISOCode")
    public var sCountryISOCode: String

    public init(sCountryISOCode: String) {
        self.sCountryISOCode = sCountryISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryCurrencyResponse")
public struct CountryCurrencyResponse {
    @SOAPElement(name: "CountryCurrencyResult")
    public var countryCurrencyResult: TCurrency

    public init(countryCurrencyResult: TCurrency) {
        self.countryCurrencyResult = countryCurrencyResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryFlag")
public struct CountryFlag {
    @SOAPElement(name: "sCountryISOCode")
    public var sCountryISOCode: String

    public init(sCountryISOCode: String) {
        self.sCountryISOCode = sCountryISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryFlagResponse")
public struct CountryFlagResponse {
    @SOAPElement(name: "CountryFlagResult")
    public var countryFlagResult: String

    public init(countryFlagResult: String) {
        self.countryFlagResult = countryFlagResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryIntPhoneCode")
public struct CountryIntPhoneCode {
    @SOAPElement(name: "sCountryISOCode")
    public var sCountryISOCode: String

    public init(sCountryISOCode: String) {
        self.sCountryISOCode = sCountryISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountryIntPhoneCodeResponse")
public struct CountryIntPhoneCodeResponse {
    @SOAPElement(name: "CountryIntPhoneCodeResult")
    public var countryIntPhoneCodeResult: String

    public init(countryIntPhoneCodeResult: String) {
        self.countryIntPhoneCodeResult = countryIntPhoneCodeResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "FullCountryInfo")
public struct FullCountryInfo {
    @SOAPElement(name: "sCountryISOCode")
    public var sCountryISOCode: String

    public init(sCountryISOCode: String) {
        self.sCountryISOCode = sCountryISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "FullCountryInfoResponse")
public struct FullCountryInfoResponse {
    @SOAPElement(name: "FullCountryInfoResult")
    public var fullCountryInfoResult: TCountryInfo

    public init(fullCountryInfoResult: TCountryInfo) {
        self.fullCountryInfoResult = fullCountryInfoResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "FullCountryInfoAllCountries")
public struct FullCountryInfoAllCountries {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "FullCountryInfoAllCountriesResponse")
public struct FullCountryInfoAllCountriesResponse {
    @SOAPElement(name: "FullCountryInfoAllCountriesResult")
    public var fullCountryInfoAllCountriesResult: ArrayOftCountryInfo

    public init(fullCountryInfoAllCountriesResult: ArrayOftCountryInfo) {
        self.fullCountryInfoAllCountriesResult = fullCountryInfoAllCountriesResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountriesUsingCurrency")
public struct CountriesUsingCurrency {
    @SOAPElement(name: "sISOCurrencyCode")
    public var sISOCurrencyCode: String

    public init(sISOCurrencyCode: String) {
        self.sISOCurrencyCode = sISOCurrencyCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "CountriesUsingCurrencyResponse")
public struct CountriesUsingCurrencyResponse {
    @SOAPElement(name: "CountriesUsingCurrencyResult")
    public var countriesUsingCurrencyResult: ArrayOftCountryCodeAndName

    public init(countriesUsingCurrencyResult: ArrayOftCountryCodeAndName) {
        self.countriesUsingCurrencyResult = countriesUsingCurrencyResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfLanguagesByName")
public struct ListOfLanguagesByName {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfLanguagesByNameResponse")
public struct ListOfLanguagesByNameResponse {
    @SOAPElement(name: "ListOfLanguagesByNameResult")
    public var listOfLanguagesByNameResult: ArrayOftLanguage

    public init(listOfLanguagesByNameResult: ArrayOftLanguage) {
        self.listOfLanguagesByNameResult = listOfLanguagesByNameResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfLanguagesByCode")
public struct ListOfLanguagesByCode {
    public init() {
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "ListOfLanguagesByCodeResponse")
public struct ListOfLanguagesByCodeResponse {
    @SOAPElement(name: "ListOfLanguagesByCodeResult")
    public var listOfLanguagesByCodeResult: ArrayOftLanguage

    public init(listOfLanguagesByCodeResult: ArrayOftLanguage) {
        self.listOfLanguagesByCodeResult = listOfLanguagesByCodeResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "LanguageName")
public struct LanguageName {
    @SOAPElement(name: "sISOCode")
    public var sISOCode: String

    public init(sISOCode: String) {
        self.sISOCode = sISOCode
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "LanguageNameResponse")
public struct LanguageNameResponse {
    @SOAPElement(name: "LanguageNameResult")
    public var languageNameResult: String

    public init(languageNameResult: String) {
        self.languageNameResult = languageNameResult
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "LanguageISOCode")
public struct LanguageISOCode {
    @SOAPElement(name: "sLanguageName")
    public var sLanguageName: String

    public init(sLanguageName: String) {
        self.sLanguageName = sLanguageName
    }
}

@SOAPType(namespace: "http://www.oorsprong.org/websamples.countryinfo", name: "LanguageISOCodeResponse")
public struct LanguageISOCodeResponse {
    @SOAPElement(name: "LanguageISOCodeResult")
    public var languageISOCodeResult: String

    public init(languageISOCodeResult: String) {
        self.languageISOCodeResult = languageISOCodeResult
    }
}

@SOAPService(endpoint: "http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso", soapVersion: .v1_1)
public actor CountryInfoService {
    @SOAPOperation(name: "ListOfContinentsByName", soapAction: "", bodyWireNames: ["ListOfContinentsByName"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfContinentsByName(parameters: ListOfContinentsByName) async throws -> ListOfContinentsByNameResponse

    @SOAPOperation(name: "ListOfContinentsByCode", soapAction: "", bodyWireNames: ["ListOfContinentsByCode"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfContinentsByCode(parameters: ListOfContinentsByCode) async throws -> ListOfContinentsByCodeResponse

    @SOAPOperation(name: "ListOfCurrenciesByName", soapAction: "", bodyWireNames: ["ListOfCurrenciesByName"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfCurrenciesByName(parameters: ListOfCurrenciesByName) async throws -> ListOfCurrenciesByNameResponse

    @SOAPOperation(name: "ListOfCurrenciesByCode", soapAction: "", bodyWireNames: ["ListOfCurrenciesByCode"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfCurrenciesByCode(parameters: ListOfCurrenciesByCode) async throws -> ListOfCurrenciesByCodeResponse

    @SOAPOperation(name: "CurrencyName", soapAction: "", bodyWireNames: ["CurrencyName"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func currencyName(parameters: CurrencyName) async throws -> CurrencyNameResponse

    @SOAPOperation(name: "ListOfCountryNamesByCode", soapAction: "", bodyWireNames: ["ListOfCountryNamesByCode"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfCountryNamesByCode(parameters: ListOfCountryNamesByCode) async throws -> ListOfCountryNamesByCodeResponse

    @SOAPOperation(name: "ListOfCountryNamesByName", soapAction: "", bodyWireNames: ["ListOfCountryNamesByName"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfCountryNamesByName(parameters: ListOfCountryNamesByName) async throws -> ListOfCountryNamesByNameResponse

    @SOAPOperation(name: "ListOfCountryNamesGroupedByContinent", soapAction: "", bodyWireNames: ["ListOfCountryNamesGroupedByContinent"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfCountryNamesGroupedByContinent(parameters: ListOfCountryNamesGroupedByContinent) async throws -> ListOfCountryNamesGroupedByContinentResponse

    @SOAPOperation(name: "CountryName", soapAction: "", bodyWireNames: ["CountryName"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func countryName(parameters: CountryName) async throws -> CountryNameResponse

    @SOAPOperation(name: "CountryISOCode", soapAction: "", bodyWireNames: ["CountryISOCode"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func countryISOCode(parameters: CountryISOCode) async throws -> CountryISOCodeResponse

    @SOAPOperation(name: "CapitalCity", soapAction: "", bodyWireNames: ["CapitalCity"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func capitalCity(parameters: CapitalCity) async throws -> CapitalCityResponse

    @SOAPOperation(name: "CountryCurrency", soapAction: "", bodyWireNames: ["CountryCurrency"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func countryCurrency(parameters: CountryCurrency) async throws -> CountryCurrencyResponse

    @SOAPOperation(name: "CountryFlag", soapAction: "", bodyWireNames: ["CountryFlag"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func countryFlag(parameters: CountryFlag) async throws -> CountryFlagResponse

    @SOAPOperation(name: "CountryIntPhoneCode", soapAction: "", bodyWireNames: ["CountryIntPhoneCode"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func countryIntPhoneCode(parameters: CountryIntPhoneCode) async throws -> CountryIntPhoneCodeResponse

    @SOAPOperation(name: "FullCountryInfo", soapAction: "", bodyWireNames: ["FullCountryInfo"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func fullCountryInfo(parameters: FullCountryInfo) async throws -> FullCountryInfoResponse

    @SOAPOperation(name: "FullCountryInfoAllCountries", soapAction: "", bodyWireNames: ["FullCountryInfoAllCountries"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func fullCountryInfoAllCountries(parameters: FullCountryInfoAllCountries) async throws -> FullCountryInfoAllCountriesResponse

    @SOAPOperation(name: "CountriesUsingCurrency", soapAction: "", bodyWireNames: ["CountriesUsingCurrency"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func countriesUsingCurrency(parameters: CountriesUsingCurrency) async throws -> CountriesUsingCurrencyResponse

    @SOAPOperation(name: "ListOfLanguagesByName", soapAction: "", bodyWireNames: ["ListOfLanguagesByName"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfLanguagesByName(parameters: ListOfLanguagesByName) async throws -> ListOfLanguagesByNameResponse

    @SOAPOperation(name: "ListOfLanguagesByCode", soapAction: "", bodyWireNames: ["ListOfLanguagesByCode"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func listOfLanguagesByCode(parameters: ListOfLanguagesByCode) async throws -> ListOfLanguagesByCodeResponse

    @SOAPOperation(name: "LanguageName", soapAction: "", bodyWireNames: ["LanguageName"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func languageName(parameters: LanguageName) async throws -> LanguageNameResponse

    @SOAPOperation(name: "LanguageISOCode", soapAction: "", bodyWireNames: ["LanguageISOCode"], bodyNamespace: "http://www.oorsprong.org/websamples.countryinfo")
    public func languageISOCode(parameters: LanguageISOCode) async throws -> LanguageISOCodeResponse
}
