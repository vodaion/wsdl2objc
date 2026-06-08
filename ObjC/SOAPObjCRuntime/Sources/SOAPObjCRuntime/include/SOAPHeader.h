#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// One block inside `<soap:Header>`. WSSE UsernameToken is built-in; any
/// `SOAPModel` subclass can also serve as a header via `<SOAPHeaderModel>`
/// adoption (the default implementation forwards to `encodeSOAPBody:`).
@protocol SOAPHeader <NSObject>
- (nullable NSString *)encodeSOAPHeader:(NSError **)error;
@end

@protocol SOAPHeaderProvider <NSObject>
- (NSArray<id<SOAPHeader>> *)headersForSOAPAction:(NSString *)action;
@end

/// Returns the same fixed list on every call.
@interface SOAPFixedHeaderProvider : NSObject <SOAPHeaderProvider>
- (instancetype)initWithHeaders:(NSArray<id<SOAPHeader>> *)headers
    NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end

/// WS-Security UsernameToken with plain-text password.
@interface WSSEUsernameToken : NSObject <SOAPHeader>
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *password;

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
    NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
