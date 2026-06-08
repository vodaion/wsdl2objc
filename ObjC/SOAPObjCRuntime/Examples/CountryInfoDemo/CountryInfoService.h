// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://www.oorsprong.org/websamples.countryinfo

#import <Foundation/Foundation.h>
@import SOAPObjCRuntime;

NS_ASSUME_NONNULL_BEGIN

@class TContinent, TCurrency, TCountryCodeAndName, TCountryCodeAndNameGroupedByContinent, ArrayOftCountryCodeAndName, TCountryInfo, ArrayOftLanguage, TLanguage, ArrayOftContinent, ArrayOftCurrency, ArrayOftCountryCodeAndNameGroupedByContinent, ArrayOftCountryInfo, ListOfContinentsByName, ListOfContinentsByNameResponse, ListOfContinentsByCode, ListOfContinentsByCodeResponse, ListOfCurrenciesByName, ListOfCurrenciesByNameResponse, ListOfCurrenciesByCode, ListOfCurrenciesByCodeResponse, CurrencyName, CurrencyNameResponse, ListOfCountryNamesByCode, ListOfCountryNamesByCodeResponse, ListOfCountryNamesByName, ListOfCountryNamesByNameResponse, ListOfCountryNamesGroupedByContinent, ListOfCountryNamesGroupedByContinentResponse, CountryName, CountryNameResponse, CountryISOCode, CountryISOCodeResponse, CapitalCity, CapitalCityResponse, CountryCurrency, CountryCurrencyResponse, CountryFlag, CountryFlagResponse, CountryIntPhoneCode, CountryIntPhoneCodeResponse, FullCountryInfo, FullCountryInfoResponse, FullCountryInfoAllCountries, FullCountryInfoAllCountriesResponse, CountriesUsingCurrency, CountriesUsingCurrencyResponse, ListOfLanguagesByName, ListOfLanguagesByNameResponse, ListOfLanguagesByCode, ListOfLanguagesByCodeResponse, LanguageName, LanguageNameResponse, LanguageISOCode, LanguageISOCodeResponse;

@interface TContinent : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCode;
@property (nonatomic, strong, nullable) NSString *sName;
@end

@interface TCurrency : SOAPModel
@property (nonatomic, strong, nullable) NSString *sISOCode;
@property (nonatomic, strong, nullable) NSString *sName;
@end

@interface TCountryCodeAndName : SOAPModel
@property (nonatomic, strong, nullable) NSString *sISOCode;
@property (nonatomic, strong, nullable) NSString *sName;
@end

@interface TCountryCodeAndNameGroupedByContinent : SOAPModel
@property (nonatomic, strong, nullable) TContinent *continent;
@property (nonatomic, strong, nullable) ArrayOftCountryCodeAndName *countryCodeAndNames;
@end

@interface ArrayOftCountryCodeAndName : SOAPModel
@property (nonatomic, strong, nullable) NSArray<TCountryCodeAndName *> *tCountryCodeAndName;
@end

@interface TCountryInfo : SOAPModel
@property (nonatomic, strong, nullable) NSString *sISOCode;
@property (nonatomic, strong, nullable) NSString *sName;
@property (nonatomic, strong, nullable) NSString *sCapitalCity;
@property (nonatomic, strong, nullable) NSString *sPhoneCode;
@property (nonatomic, strong, nullable) NSString *sContinentCode;
@property (nonatomic, strong, nullable) NSString *sCurrencyISOCode;
@property (nonatomic, strong, nullable) NSString *sCountryFlag;
@property (nonatomic, strong, nullable) ArrayOftLanguage *languages;
@end

@interface ArrayOftLanguage : SOAPModel
@property (nonatomic, strong, nullable) NSArray<TLanguage *> *tLanguage;
@end

@interface TLanguage : SOAPModel
@property (nonatomic, strong, nullable) NSString *sISOCode;
@property (nonatomic, strong, nullable) NSString *sName;
@end

@interface ArrayOftContinent : SOAPModel
@property (nonatomic, strong, nullable) NSArray<TContinent *> *tContinent;
@end

@interface ArrayOftCurrency : SOAPModel
@property (nonatomic, strong, nullable) NSArray<TCurrency *> *tCurrency;
@end

@interface ArrayOftCountryCodeAndNameGroupedByContinent : SOAPModel
@property (nonatomic, strong, nullable) NSArray<TCountryCodeAndNameGroupedByContinent *> *tCountryCodeAndNameGroupedByContinent;
@end

@interface ArrayOftCountryInfo : SOAPModel
@property (nonatomic, strong, nullable) NSArray<TCountryInfo *> *tCountryInfo;
@end

@interface ListOfContinentsByName : SOAPModel
@end

@interface ListOfContinentsByNameResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftContinent *listOfContinentsByNameResult;
@end

@interface ListOfContinentsByCode : SOAPModel
@end

@interface ListOfContinentsByCodeResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftContinent *listOfContinentsByCodeResult;
@end

@interface ListOfCurrenciesByName : SOAPModel
@end

@interface ListOfCurrenciesByNameResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftCurrency *listOfCurrenciesByNameResult;
@end

@interface ListOfCurrenciesByCode : SOAPModel
@end

@interface ListOfCurrenciesByCodeResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftCurrency *listOfCurrenciesByCodeResult;
@end

@interface CurrencyName : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCurrencyISOCode;
@end

@interface CurrencyNameResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *currencyNameResult;
@end

@interface ListOfCountryNamesByCode : SOAPModel
@end

@interface ListOfCountryNamesByCodeResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftCountryCodeAndName *listOfCountryNamesByCodeResult;
@end

@interface ListOfCountryNamesByName : SOAPModel
@end

@interface ListOfCountryNamesByNameResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftCountryCodeAndName *listOfCountryNamesByNameResult;
@end

@interface ListOfCountryNamesGroupedByContinent : SOAPModel
@end

@interface ListOfCountryNamesGroupedByContinentResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftCountryCodeAndNameGroupedByContinent *listOfCountryNamesGroupedByContinentResult;
@end

@interface CountryName : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCountryISOCode;
@end

@interface CountryNameResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryNameResult;
@end

@interface CountryISOCode : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCountryName;
@end

@interface CountryISOCodeResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryISOCodeResult;
@end

@interface CapitalCity : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCountryISOCode;
@end

@interface CapitalCityResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *capitalCityResult;
@end

@interface CountryCurrency : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCountryISOCode;
@end

@interface CountryCurrencyResponse : SOAPModel
@property (nonatomic, strong, nullable) TCurrency *countryCurrencyResult;
@end

@interface CountryFlag : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCountryISOCode;
@end

@interface CountryFlagResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryFlagResult;
@end

@interface CountryIntPhoneCode : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCountryISOCode;
@end

@interface CountryIntPhoneCodeResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryIntPhoneCodeResult;
@end

@interface FullCountryInfo : SOAPModel
@property (nonatomic, strong, nullable) NSString *sCountryISOCode;
@end

@interface FullCountryInfoResponse : SOAPModel
@property (nonatomic, strong, nullable) TCountryInfo *fullCountryInfoResult;
@end

@interface FullCountryInfoAllCountries : SOAPModel
@end

@interface FullCountryInfoAllCountriesResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftCountryInfo *fullCountryInfoAllCountriesResult;
@end

@interface CountriesUsingCurrency : SOAPModel
@property (nonatomic, strong, nullable) NSString *sISOCurrencyCode;
@end

@interface CountriesUsingCurrencyResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftCountryCodeAndName *countriesUsingCurrencyResult;
@end

@interface ListOfLanguagesByName : SOAPModel
@end

@interface ListOfLanguagesByNameResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftLanguage *listOfLanguagesByNameResult;
@end

@interface ListOfLanguagesByCode : SOAPModel
@end

@interface ListOfLanguagesByCodeResponse : SOAPModel
@property (nonatomic, strong, nullable) ArrayOftLanguage *listOfLanguagesByCodeResult;
@end

@interface LanguageName : SOAPModel
@property (nonatomic, strong, nullable) NSString *sISOCode;
@end

@interface LanguageNameResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *languageNameResult;
@end

@interface LanguageISOCode : SOAPModel
@property (nonatomic, strong, nullable) NSString *sLanguageName;
@end

@interface LanguageISOCodeResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *languageISOCodeResult;
@end

@interface CountryInfoService : SOAPService
- (void)listOfContinentsByNameWithParameters:(ListOfContinentsByName *)parameters
              completion:(void (^)(ListOfContinentsByNameResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfContinentsByCodeWithParameters:(ListOfContinentsByCode *)parameters
              completion:(void (^)(ListOfContinentsByCodeResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfCurrenciesByNameWithParameters:(ListOfCurrenciesByName *)parameters
              completion:(void (^)(ListOfCurrenciesByNameResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfCurrenciesByCodeWithParameters:(ListOfCurrenciesByCode *)parameters
              completion:(void (^)(ListOfCurrenciesByCodeResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)currencyNameWithParameters:(CurrencyName *)parameters
              completion:(void (^)(CurrencyNameResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfCountryNamesByCodeWithParameters:(ListOfCountryNamesByCode *)parameters
              completion:(void (^)(ListOfCountryNamesByCodeResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfCountryNamesByNameWithParameters:(ListOfCountryNamesByName *)parameters
              completion:(void (^)(ListOfCountryNamesByNameResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfCountryNamesGroupedByContinentWithParameters:(ListOfCountryNamesGroupedByContinent *)parameters
              completion:(void (^)(ListOfCountryNamesGroupedByContinentResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)countryNameWithParameters:(CountryName *)parameters
              completion:(void (^)(CountryNameResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)countryISOCodeWithParameters:(CountryISOCode *)parameters
              completion:(void (^)(CountryISOCodeResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)capitalCityWithParameters:(CapitalCity *)parameters
              completion:(void (^)(CapitalCityResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)countryCurrencyWithParameters:(CountryCurrency *)parameters
              completion:(void (^)(CountryCurrencyResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)countryFlagWithParameters:(CountryFlag *)parameters
              completion:(void (^)(CountryFlagResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)countryIntPhoneCodeWithParameters:(CountryIntPhoneCode *)parameters
              completion:(void (^)(CountryIntPhoneCodeResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)fullCountryInfoWithParameters:(FullCountryInfo *)parameters
              completion:(void (^)(FullCountryInfoResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)fullCountryInfoAllCountriesWithParameters:(FullCountryInfoAllCountries *)parameters
              completion:(void (^)(FullCountryInfoAllCountriesResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)countriesUsingCurrencyWithParameters:(CountriesUsingCurrency *)parameters
              completion:(void (^)(CountriesUsingCurrencyResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfLanguagesByNameWithParameters:(ListOfLanguagesByName *)parameters
              completion:(void (^)(ListOfLanguagesByNameResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)listOfLanguagesByCodeWithParameters:(ListOfLanguagesByCode *)parameters
              completion:(void (^)(ListOfLanguagesByCodeResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)languageNameWithParameters:(LanguageName *)parameters
              completion:(void (^)(LanguageNameResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)languageISOCodeWithParameters:(LanguageISOCode *)parameters
              completion:(void (^)(LanguageISOCodeResponse * _Nullable response, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
