#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents a SOAP fault decoded from `<soap:Fault>` in a response body.
/// Surfaced as the `userInfo[SOAPFaultKey]` value of an `NSError` whose
/// domain is `SOAPErrorDomain` and code is `SOAPErrorCodeFault`.
@interface SOAPFault : NSObject

@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *reason;
@property (nonatomic, copy, readonly, nullable) NSString *detail;
@property (nonatomic, readonly) NSInteger httpStatus;

- (instancetype)initWithCode:(NSString *)code
                       reason:(NSString *)reason
                       detail:(nullable NSString *)detail
                   httpStatus:(NSInteger)httpStatus
    NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

FOUNDATION_EXPORT NSString *const SOAPFaultKey;

NS_ASSUME_NONNULL_END
