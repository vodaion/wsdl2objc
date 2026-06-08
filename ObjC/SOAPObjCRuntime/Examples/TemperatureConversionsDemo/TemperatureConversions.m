// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://webservices.daehosting.com/temperature

#import "TemperatureConversions.h"

@implementation CelsiusToFahrenheit
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"CelsiusToFahrenheit")
    SOAP_ELEMENT(nCelsius, @"nCelsius")
SOAP_TYPE_END
@end

@implementation CelsiusToFahrenheitResponse
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"CelsiusToFahrenheitResponse")
    SOAP_ELEMENT(celsiusToFahrenheitResult, @"CelsiusToFahrenheitResult")
SOAP_TYPE_END
@end

@implementation FahrenheitToCelsius
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"FahrenheitToCelsius")
    SOAP_ELEMENT(nFahrenheit, @"nFahrenheit")
SOAP_TYPE_END
@end

@implementation FahrenheitToCelsiusResponse
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"FahrenheitToCelsiusResponse")
    SOAP_ELEMENT(fahrenheitToCelsiusResult, @"FahrenheitToCelsiusResult")
SOAP_TYPE_END
@end

@implementation WindChillInCelsius
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"WindChillInCelsius")
    SOAP_ELEMENT(nCelsius, @"nCelsius"),
    SOAP_ELEMENT(nWindSpeed, @"nWindSpeed")
SOAP_TYPE_END
@end

@implementation WindChillInCelsiusResponse
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"WindChillInCelsiusResponse")
    SOAP_ELEMENT(windChillInCelsiusResult, @"WindChillInCelsiusResult")
SOAP_TYPE_END
@end

@implementation WindChillInFahrenheit
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"WindChillInFahrenheit")
    SOAP_ELEMENT(nFahrenheit, @"nFahrenheit"),
    SOAP_ELEMENT(nWindSpeed, @"nWindSpeed")
SOAP_TYPE_END
@end

@implementation WindChillInFahrenheitResponse
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"WindChillInFahrenheitResponse")
    SOAP_ELEMENT(windChillInFahrenheitResult, @"WindChillInFahrenheitResult")
SOAP_TYPE_END
@end

@implementation TemperatureConversionsService
SOAP_SERVICE(@"http://webservices.daehosting.com/services/TemperatureConversions.wso", SOAPVersionV1_1)

- (void)celsiusToFahrenheitWithParameters:(CelsiusToFahrenheit *)parameters
              completion:(void (^)(CelsiusToFahrenheitResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"CelsiusToFahrenheit"
                soapAction:@""
                   request:parameters
             responseClass:CelsiusToFahrenheitResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)fahrenheitToCelsiusWithParameters:(FahrenheitToCelsius *)parameters
              completion:(void (^)(FahrenheitToCelsiusResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"FahrenheitToCelsius"
                soapAction:@""
                   request:parameters
             responseClass:FahrenheitToCelsiusResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)windChillInCelsiusWithParameters:(WindChillInCelsius *)parameters
              completion:(void (^)(WindChillInCelsiusResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"WindChillInCelsius"
                soapAction:@""
                   request:parameters
             responseClass:WindChillInCelsiusResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

- (void)windChillInFahrenheitWithParameters:(WindChillInFahrenheit *)parameters
              completion:(void (^)(WindChillInFahrenheitResponse * _Nullable response, NSError * _Nullable error))completion {
    [self invokeOperation:@"WindChillInFahrenheit"
                soapAction:@""
                   request:parameters
             responseClass:WindChillInFahrenheitResponse.class
                   headers:nil
                completion:(void (^)(id, NSError *))completion];
}

@end

