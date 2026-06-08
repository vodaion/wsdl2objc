// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://www.oorsprong.org/websamples.countryinfo

#import "CountryInfoService.h"

@implementation TContinent
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"tContinent")
    SOAP_ELEMENT(sCode, @"sCode"),
    SOAP_ELEMENT(sName, @"sName")
SOAP_TYPE_END
@end

@implementation TCurrency
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"tCurrency")
    SOAP_ELEMENT(sISOCode, @"sISOCode"),
    SOAP_ELEMENT(sName, @"sName")
SOAP_TYPE_END
@end

@implementation TCountryCodeAndName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"tCountryCodeAndName")
    SOAP_ELEMENT(sISOCode, @"sISOCode"),
    SOAP_ELEMENT(sName, @"sName")
SOAP_TYPE_END
@end

@implementation TCountryCodeAndNameGroupedByContinent
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"tCountryCodeAndNameGroupedByContinent")
    SOAP_ELEMENT(continent, @"Continent"),
    SOAP_ELEMENT(countryCodeAndNames, @"CountryCodeAndNames")
SOAP_TYPE_END
@end

@implementation ArrayOftCountryCodeAndName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ArrayOftCountryCodeAndName")
    SOAP_ELEMENT_ARRAY(tCountryCodeAndName, @"tCountryCodeAndName", TCountryCodeAndName)
SOAP_TYPE_END
@end

@implementation TCountryInfo
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"tCountryInfo")
    SOAP_ELEMENT(sISOCode, @"sISOCode"),
    SOAP_ELEMENT(sName, @"sName"),
    SOAP_ELEMENT(sCapitalCity, @"sCapitalCity"),
    SOAP_ELEMENT(sPhoneCode, @"sPhoneCode"),
    SOAP_ELEMENT(sContinentCode, @"sContinentCode"),
    SOAP_ELEMENT(sCurrencyISOCode, @"sCurrencyISOCode"),
    SOAP_ELEMENT(sCountryFlag, @"sCountryFlag"),
    SOAP_ELEMENT(languages, @"Languages")
SOAP_TYPE_END
@end

@implementation ArrayOftLanguage
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ArrayOftLanguage")
    SOAP_ELEMENT_ARRAY(tLanguage, @"tLanguage", TLanguage)
SOAP_TYPE_END
@end

@implementation TLanguage
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"tLanguage")
    SOAP_ELEMENT(sISOCode, @"sISOCode"),
    SOAP_ELEMENT(sName, @"sName")
SOAP_TYPE_END
@end

@implementation ArrayOftContinent
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ArrayOftContinent")
    SOAP_ELEMENT_ARRAY(tContinent, @"tContinent", TContinent)
SOAP_TYPE_END
@end

@implementation ArrayOftCurrency
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ArrayOftCurrency")
    SOAP_ELEMENT_ARRAY(tCurrency, @"tCurrency", TCurrency)
SOAP_TYPE_END
@end

@implementation ArrayOftCountryCodeAndNameGroupedByContinent
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ArrayOftCountryCodeAndNameGroupedByContinent")
    SOAP_ELEMENT_ARRAY(tCountryCodeAndNameGroupedByContinent, @"tCountryCodeAndNameGroupedByContinent", TCountryCodeAndNameGroupedByContinent)
SOAP_TYPE_END
@end

@implementation ArrayOftCountryInfo
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ArrayOftCountryInfo")
    SOAP_ELEMENT_ARRAY(tCountryInfo, @"tCountryInfo", TCountryInfo)
SOAP_TYPE_END
@end

@implementation ListOfContinentsByName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfContinentsByName")
SOAP_TYPE_END
@end

@implementation ListOfContinentsByNameResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfContinentsByNameResponse")
    SOAP_ELEMENT(listOfContinentsByNameResult, @"ListOfContinentsByNameResult")
SOAP_TYPE_END
@end

@implementation ListOfContinentsByCode
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfContinentsByCode")
SOAP_TYPE_END
@end

@implementation ListOfContinentsByCodeResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfContinentsByCodeResponse")
    SOAP_ELEMENT(listOfContinentsByCodeResult, @"ListOfContinentsByCodeResult")
SOAP_TYPE_END
@end

@implementation ListOfCurrenciesByName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCurrenciesByName")
SOAP_TYPE_END
@end

@implementation ListOfCurrenciesByNameResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCurrenciesByNameResponse")
    SOAP_ELEMENT(listOfCurrenciesByNameResult, @"ListOfCurrenciesByNameResult")
SOAP_TYPE_END
@end

@implementation ListOfCurrenciesByCode
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCurrenciesByCode")
SOAP_TYPE_END
@end

@implementation ListOfCurrenciesByCodeResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCurrenciesByCodeResponse")
    SOAP_ELEMENT(listOfCurrenciesByCodeResult, @"ListOfCurrenciesByCodeResult")
SOAP_TYPE_END
@end

@implementation CurrencyName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CurrencyName")
    SOAP_ELEMENT(sCurrencyISOCode, @"sCurrencyISOCode")
SOAP_TYPE_END
@end

@implementation CurrencyNameResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CurrencyNameResponse")
    SOAP_ELEMENT(currencyNameResult, @"CurrencyNameResult")
SOAP_TYPE_END
@end

@implementation ListOfCountryNamesByCode
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCountryNamesByCode")
SOAP_TYPE_END
@end

@implementation ListOfCountryNamesByCodeResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCountryNamesByCodeResponse")
    SOAP_ELEMENT(listOfCountryNamesByCodeResult, @"ListOfCountryNamesByCodeResult")
SOAP_TYPE_END
@end

@implementation ListOfCountryNamesByName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCountryNamesByName")
SOAP_TYPE_END
@end

@implementation ListOfCountryNamesByNameResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCountryNamesByNameResponse")
    SOAP_ELEMENT(listOfCountryNamesByNameResult, @"ListOfCountryNamesByNameResult")
SOAP_TYPE_END
@end

@implementation ListOfCountryNamesGroupedByContinent
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCountryNamesGroupedByContinent")
SOAP_TYPE_END
@end

@implementation ListOfCountryNamesGroupedByContinentResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfCountryNamesGroupedByContinentResponse")
    SOAP_ELEMENT(listOfCountryNamesGroupedByContinentResult, @"ListOfCountryNamesGroupedByContinentResult")
SOAP_TYPE_END
@end

@implementation CountryName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryName")
    SOAP_ELEMENT(sCountryISOCode, @"sCountryISOCode")
SOAP_TYPE_END
@end

@implementation CountryNameResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryNameResponse")
    SOAP_ELEMENT(countryNameResult, @"CountryNameResult")
SOAP_TYPE_END
@end

@implementation CountryISOCode
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryISOCode")
    SOAP_ELEMENT(sCountryName, @"sCountryName")
SOAP_TYPE_END
@end

@implementation CountryISOCodeResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryISOCodeResponse")
    SOAP_ELEMENT(countryISOCodeResult, @"CountryISOCodeResult")
SOAP_TYPE_END
@end

@implementation CapitalCity
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CapitalCity")
    SOAP_ELEMENT(sCountryISOCode, @"sCountryISOCode")
SOAP_TYPE_END
@end

@implementation CapitalCityResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CapitalCityResponse")
    SOAP_ELEMENT(capitalCityResult, @"CapitalCityResult")
SOAP_TYPE_END
@end

@implementation CountryCurrency
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryCurrency")
    SOAP_ELEMENT(sCountryISOCode, @"sCountryISOCode")
SOAP_TYPE_END
@end

@implementation CountryCurrencyResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryCurrencyResponse")
    SOAP_ELEMENT(countryCurrencyResult, @"CountryCurrencyResult")
SOAP_TYPE_END
@end

@implementation CountryFlag
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryFlag")
    SOAP_ELEMENT(sCountryISOCode, @"sCountryISOCode")
SOAP_TYPE_END
@end

@implementation CountryFlagResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryFlagResponse")
    SOAP_ELEMENT(countryFlagResult, @"CountryFlagResult")
SOAP_TYPE_END
@end

@implementation CountryIntPhoneCode
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryIntPhoneCode")
    SOAP_ELEMENT(sCountryISOCode, @"sCountryISOCode")
SOAP_TYPE_END
@end

@implementation CountryIntPhoneCodeResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountryIntPhoneCodeResponse")
    SOAP_ELEMENT(countryIntPhoneCodeResult, @"CountryIntPhoneCodeResult")
SOAP_TYPE_END
@end

@implementation FullCountryInfo
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"FullCountryInfo")
    SOAP_ELEMENT(sCountryISOCode, @"sCountryISOCode")
SOAP_TYPE_END
@end

@implementation FullCountryInfoResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"FullCountryInfoResponse")
    SOAP_ELEMENT(fullCountryInfoResult, @"FullCountryInfoResult")
SOAP_TYPE_END
@end

@implementation FullCountryInfoAllCountries
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"FullCountryInfoAllCountries")
SOAP_TYPE_END
@end

@implementation FullCountryInfoAllCountriesResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"FullCountryInfoAllCountriesResponse")
    SOAP_ELEMENT(fullCountryInfoAllCountriesResult, @"FullCountryInfoAllCountriesResult")
SOAP_TYPE_END
@end

@implementation CountriesUsingCurrency
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountriesUsingCurrency")
    SOAP_ELEMENT(sISOCurrencyCode, @"sISOCurrencyCode")
SOAP_TYPE_END
@end

@implementation CountriesUsingCurrencyResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"CountriesUsingCurrencyResponse")
    SOAP_ELEMENT(countriesUsingCurrencyResult, @"CountriesUsingCurrencyResult")
SOAP_TYPE_END
@end

@implementation ListOfLanguagesByName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfLanguagesByName")
SOAP_TYPE_END
@end

@implementation ListOfLanguagesByNameResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfLanguagesByNameResponse")
    SOAP_ELEMENT(listOfLanguagesByNameResult, @"ListOfLanguagesByNameResult")
SOAP_TYPE_END
@end

@implementation ListOfLanguagesByCode
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfLanguagesByCode")
SOAP_TYPE_END
@end

@implementation ListOfLanguagesByCodeResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"ListOfLanguagesByCodeResponse")
    SOAP_ELEMENT(listOfLanguagesByCodeResult, @"ListOfLanguagesByCodeResult")
SOAP_TYPE_END
@end

@implementation LanguageName
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"LanguageName")
    SOAP_ELEMENT(sISOCode, @"sISOCode")
SOAP_TYPE_END
@end

@implementation LanguageNameResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"LanguageNameResponse")
    SOAP_ELEMENT(languageNameResult, @"LanguageNameResult")
SOAP_TYPE_END
@end

@implementation LanguageISOCode
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"LanguageISOCode")
    SOAP_ELEMENT(sLanguageName, @"sLanguageName")
SOAP_TYPE_END
@end

@implementation LanguageISOCodeResponse
SOAP_TYPE_BEGIN(@"http://www.oorsprong.org/websamples.countryinfo", @"LanguageISOCodeResponse")
    SOAP_ELEMENT(languageISOCodeResult, @"LanguageISOCodeResult")
SOAP_TYPE_END
@end

@implementation CountryInfoService
SOAP_SERVICE(@"http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso", SOAPVersionV1_1)

- (void)listOfContinentsByNameWithParameters:(ListOfContinentsByName *)parameters
              completion:(void (^)(ListOfContinentsByNameResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfContinentsByName"
                soapAction:@""
                   request:parameters
             responseClass:ListOfContinentsByNameResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfContinentsByCodeWithParameters:(ListOfContinentsByCode *)parameters
              completion:(void (^)(ListOfContinentsByCodeResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfContinentsByCode"
                soapAction:@""
                   request:parameters
             responseClass:ListOfContinentsByCodeResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfCurrenciesByNameWithParameters:(ListOfCurrenciesByName *)parameters
              completion:(void (^)(ListOfCurrenciesByNameResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfCurrenciesByName"
                soapAction:@""
                   request:parameters
             responseClass:ListOfCurrenciesByNameResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfCurrenciesByCodeWithParameters:(ListOfCurrenciesByCode *)parameters
              completion:(void (^)(ListOfCurrenciesByCodeResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfCurrenciesByCode"
                soapAction:@""
                   request:parameters
             responseClass:ListOfCurrenciesByCodeResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)currencyNameWithParameters:(CurrencyName *)parameters
              completion:(void (^)(CurrencyNameResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CurrencyName"
                soapAction:@""
                   request:parameters
             responseClass:CurrencyNameResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfCountryNamesByCodeWithParameters:(ListOfCountryNamesByCode *)parameters
              completion:(void (^)(ListOfCountryNamesByCodeResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfCountryNamesByCode"
                soapAction:@""
                   request:parameters
             responseClass:ListOfCountryNamesByCodeResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfCountryNamesByNameWithParameters:(ListOfCountryNamesByName *)parameters
              completion:(void (^)(ListOfCountryNamesByNameResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfCountryNamesByName"
                soapAction:@""
                   request:parameters
             responseClass:ListOfCountryNamesByNameResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfCountryNamesGroupedByContinentWithParameters:(ListOfCountryNamesGroupedByContinent *)parameters
              completion:(void (^)(ListOfCountryNamesGroupedByContinentResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfCountryNamesGroupedByContinent"
                soapAction:@""
                   request:parameters
             responseClass:ListOfCountryNamesGroupedByContinentResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)countryNameWithParameters:(CountryName *)parameters
              completion:(void (^)(CountryNameResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CountryName"
                soapAction:@""
                   request:parameters
             responseClass:CountryNameResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)countryISOCodeWithParameters:(CountryISOCode *)parameters
              completion:(void (^)(CountryISOCodeResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CountryISOCode"
                soapAction:@""
                   request:parameters
             responseClass:CountryISOCodeResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)capitalCityWithParameters:(CapitalCity *)parameters
              completion:(void (^)(CapitalCityResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CapitalCity"
                soapAction:@""
                   request:parameters
             responseClass:CapitalCityResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)countryCurrencyWithParameters:(CountryCurrency *)parameters
              completion:(void (^)(CountryCurrencyResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CountryCurrency"
                soapAction:@""
                   request:parameters
             responseClass:CountryCurrencyResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)countryFlagWithParameters:(CountryFlag *)parameters
              completion:(void (^)(CountryFlagResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CountryFlag"
                soapAction:@""
                   request:parameters
             responseClass:CountryFlagResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)countryIntPhoneCodeWithParameters:(CountryIntPhoneCode *)parameters
              completion:(void (^)(CountryIntPhoneCodeResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CountryIntPhoneCode"
                soapAction:@""
                   request:parameters
             responseClass:CountryIntPhoneCodeResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)fullCountryInfoWithParameters:(FullCountryInfo *)parameters
              completion:(void (^)(FullCountryInfoResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"FullCountryInfo"
                soapAction:@""
                   request:parameters
             responseClass:FullCountryInfoResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)fullCountryInfoAllCountriesWithParameters:(FullCountryInfoAllCountries *)parameters
              completion:(void (^)(FullCountryInfoAllCountriesResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"FullCountryInfoAllCountries"
                soapAction:@""
                   request:parameters
             responseClass:FullCountryInfoAllCountriesResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)countriesUsingCurrencyWithParameters:(CountriesUsingCurrency *)parameters
              completion:(void (^)(CountriesUsingCurrencyResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CountriesUsingCurrency"
                soapAction:@""
                   request:parameters
             responseClass:CountriesUsingCurrencyResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfLanguagesByNameWithParameters:(ListOfLanguagesByName *)parameters
              completion:(void (^)(ListOfLanguagesByNameResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfLanguagesByName"
                soapAction:@""
                   request:parameters
             responseClass:ListOfLanguagesByNameResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)listOfLanguagesByCodeWithParameters:(ListOfLanguagesByCode *)parameters
              completion:(void (^)(ListOfLanguagesByCodeResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"ListOfLanguagesByCode"
                soapAction:@""
                   request:parameters
             responseClass:ListOfLanguagesByCodeResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)languageNameWithParameters:(LanguageName *)parameters
              completion:(void (^)(LanguageNameResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"LanguageName"
                soapAction:@""
                   request:parameters
             responseClass:LanguageNameResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)languageISOCodeWithParameters:(LanguageISOCode *)parameters
              completion:(void (^)(LanguageISOCodeResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"LanguageISOCode"
                soapAction:@""
                   request:parameters
             responseClass:LanguageISOCodeResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

@end

