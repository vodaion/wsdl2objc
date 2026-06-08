// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: urn:ec.europa.eu:taxud:vies:services:checkVat:types

#import <Foundation/Foundation.h>
@import SOAPObjCRuntime;

NS_ASSUME_NONNULL_BEGIN

@class CheckVat, CheckVatResponse, CheckVatApprox, CheckVatApproxResponse;

@interface CheckVat : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryCode;
@property (nonatomic, strong, nullable) NSString *vatNumber;
@end

@interface CheckVatResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryCode;
@property (nonatomic, strong, nullable) NSString *vatNumber;
@property (nonatomic, strong, nullable) NSDate *requestDate;
@property (nonatomic, strong, nullable) NSNumber *valid;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *address;
@end

@interface CheckVatApprox : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryCode;
@property (nonatomic, strong, nullable) NSString *vatNumber;
@property (nonatomic, strong, nullable) NSString *traderName;
@property (nonatomic, strong, nullable) NSString *traderCompanyType;
@property (nonatomic, strong, nullable) NSString *traderStreet;
@property (nonatomic, strong, nullable) NSString *traderPostcode;
@property (nonatomic, strong, nullable) NSString *traderCity;
@property (nonatomic, strong, nullable) NSString *requesterCountryCode;
@property (nonatomic, strong, nullable) NSString *requesterVatNumber;
@end

@interface CheckVatApproxResponse : SOAPModel
@property (nonatomic, strong, nullable) NSString *countryCode;
@property (nonatomic, strong, nullable) NSString *vatNumber;
@property (nonatomic, strong, nullable) NSDate *requestDate;
@property (nonatomic, strong, nullable) NSNumber *valid;
@property (nonatomic, strong, nullable) NSString *traderName;
@property (nonatomic, strong, nullable) NSString *traderCompanyType;
@property (nonatomic, strong, nullable) NSString *traderAddress;
@property (nonatomic, strong, nullable) NSString *traderStreet;
@property (nonatomic, strong, nullable) NSString *traderPostcode;
@property (nonatomic, strong, nullable) NSString *traderCity;
@property (nonatomic, strong, nullable) NSString *traderNameMatch;
@property (nonatomic, strong, nullable) NSString *traderCompanyTypeMatch;
@property (nonatomic, strong, nullable) NSString *traderStreetMatch;
@property (nonatomic, strong, nullable) NSString *traderPostcodeMatch;
@property (nonatomic, strong, nullable) NSString *traderCityMatch;
@property (nonatomic, strong, nullable) NSString *requestIdentifier;
@end

@interface MatchCode : NSObject
+ (NSString *)value__1; // 1
+ (NSString *)value__2; // 2
+ (NSString *)value__3; // 3
@end

NS_ASSUME_NONNULL_END
