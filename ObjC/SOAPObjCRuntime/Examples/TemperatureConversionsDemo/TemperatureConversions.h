// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://webservices.daehosting.com/temperature

#import <Foundation/Foundation.h>
@import SOAPObjCRuntime;

NS_ASSUME_NONNULL_BEGIN

@class CelsiusToFahrenheit, CelsiusToFahrenheitResponse, FahrenheitToCelsius, FahrenheitToCelsiusResponse, WindChillInCelsius, WindChillInCelsiusResponse, WindChillInFahrenheit, WindChillInFahrenheitResponse;

@interface CelsiusToFahrenheit : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *nCelsius;
@end

@interface CelsiusToFahrenheitResponse : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *celsiusToFahrenheitResult;
@end

@interface FahrenheitToCelsius : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *nFahrenheit;
@end

@interface FahrenheitToCelsiusResponse : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *fahrenheitToCelsiusResult;
@end

@interface WindChillInCelsius : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *nCelsius;
@property (nonatomic, strong, nullable) NSDecimalNumber *nWindSpeed;
@end

@interface WindChillInCelsiusResponse : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *windChillInCelsiusResult;
@end

@interface WindChillInFahrenheit : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *nFahrenheit;
@property (nonatomic, strong, nullable) NSDecimalNumber *nWindSpeed;
@end

@interface WindChillInFahrenheitResponse : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *windChillInFahrenheitResult;
@end

@interface TemperatureConversionsService : SOAPService
- (void)celsiusToFahrenheitWithParameters:(CelsiusToFahrenheit *)parameters
              completion:(void (^)(CelsiusToFahrenheitResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)fahrenheitToCelsiusWithParameters:(FahrenheitToCelsius *)parameters
              completion:(void (^)(FahrenheitToCelsiusResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)windChillInCelsiusWithParameters:(WindChillInCelsius *)parameters
              completion:(void (^)(WindChillInCelsiusResponse * _Nullable response, NSError * _Nullable error))completion;
- (void)windChillInFahrenheitWithParameters:(WindChillInFahrenheit *)parameters
              completion:(void (^)(WindChillInFahrenheitResponse * _Nullable response, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
