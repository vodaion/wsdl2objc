// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:ec.europa.eu:taxud:vies:services:checkVat:types

#import "Ns1.h"

@implementation CheckVat
SOAP_TYPE_BEGIN(@"urn:ec.europa.eu:taxud:vies:services:checkVat:types", @"checkVat")
    SOAP_ELEMENT(countryCode, @"countryCode"),
    SOAP_ELEMENT(vatNumber, @"vatNumber")
SOAP_TYPE_END
@end

@implementation CheckVatResponse
SOAP_TYPE_BEGIN(@"urn:ec.europa.eu:taxud:vies:services:checkVat:types", @"checkVatResponse")
    SOAP_ELEMENT(countryCode, @"countryCode"),
    SOAP_ELEMENT(vatNumber, @"vatNumber"),
    SOAP_ELEMENT(requestDate, @"requestDate"),
    SOAP_ELEMENT(valid, @"valid"),
    SOAP_ELEMENT(name, @"name"),
    SOAP_ELEMENT(address, @"address")
SOAP_TYPE_END
@end

@implementation CheckVatApprox
SOAP_TYPE_BEGIN(@"urn:ec.europa.eu:taxud:vies:services:checkVat:types", @"checkVatApprox")
    SOAP_ELEMENT(countryCode, @"countryCode"),
    SOAP_ELEMENT(vatNumber, @"vatNumber"),
    SOAP_ELEMENT(traderName, @"traderName"),
    SOAP_ELEMENT(traderCompanyType, @"traderCompanyType"),
    SOAP_ELEMENT(traderStreet, @"traderStreet"),
    SOAP_ELEMENT(traderPostcode, @"traderPostcode"),
    SOAP_ELEMENT(traderCity, @"traderCity"),
    SOAP_ELEMENT(requesterCountryCode, @"requesterCountryCode"),
    SOAP_ELEMENT(requesterVatNumber, @"requesterVatNumber")
SOAP_TYPE_END
@end

@implementation CheckVatApproxResponse
SOAP_TYPE_BEGIN(@"urn:ec.europa.eu:taxud:vies:services:checkVat:types", @"checkVatApproxResponse")
    SOAP_ELEMENT(countryCode, @"countryCode"),
    SOAP_ELEMENT(vatNumber, @"vatNumber"),
    SOAP_ELEMENT(requestDate, @"requestDate"),
    SOAP_ELEMENT(valid, @"valid"),
    SOAP_ELEMENT(traderName, @"traderName"),
    SOAP_ELEMENT(traderCompanyType, @"traderCompanyType"),
    SOAP_ELEMENT(traderAddress, @"traderAddress"),
    SOAP_ELEMENT(traderStreet, @"traderStreet"),
    SOAP_ELEMENT(traderPostcode, @"traderPostcode"),
    SOAP_ELEMENT(traderCity, @"traderCity"),
    SOAP_ELEMENT(traderNameMatch, @"traderNameMatch"),
    SOAP_ELEMENT(traderCompanyTypeMatch, @"traderCompanyTypeMatch"),
    SOAP_ELEMENT(traderStreetMatch, @"traderStreetMatch"),
    SOAP_ELEMENT(traderPostcodeMatch, @"traderPostcodeMatch"),
    SOAP_ELEMENT(traderCityMatch, @"traderCityMatch"),
    SOAP_ELEMENT(requestIdentifier, @"requestIdentifier")
SOAP_TYPE_END
@end

@implementation MatchCode
+ (NSString *)value__1 { return @"1"; }
+ (NSString *)value__2 { return @"2"; }
+ (NSString *)value__3 { return @"3"; }
@end

