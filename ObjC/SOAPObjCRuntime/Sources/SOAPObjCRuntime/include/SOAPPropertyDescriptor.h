#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SOAPPropertyKind) {
    SOAPPropertyKindElement       = 1,
    SOAPPropertyKindAttribute     = 2,
    SOAPPropertyKindElementArray  = 3,
};

/// Describes one property of a SOAP type: its Swift-style name, the wire
/// element/attribute name, whether it's an element vs attribute, and the
/// declared property class (resolved at registration via runtime
/// introspection). Built by the `SOAP_ELEMENT` / `SOAP_ATTRIBUTE` /
/// `SOAP_ELEMENT_ARRAY` macros.
@interface SOAPPropertyDescriptor : NSObject

@property (nonatomic, copy, readonly) NSString *propertyName;
@property (nonatomic, copy, readonly) NSString *wireName;
@property (nonatomic, readonly) SOAPPropertyKind kind;
/// The declared static type of the property — e.g. `[NSString class]`,
/// `[NSDecimalNumber class]`, `[NSDate class]`, a custom `SOAPModel`
/// subclass. For arrays this is `[NSArray class]`; the element type is
/// `itemClass`.
@property (nonatomic, readonly) Class propertyClass;
/// Item class for `SOAPPropertyKindElementArray`. nil for other kinds.
@property (nonatomic, readonly, nullable) Class itemClass;

+ (instancetype)elementForProperty:(NSString *)property
                          wireName:(NSString *)wireName
                           onClass:(Class)owner;

+ (instancetype)attributeForProperty:(NSString *)property
                            wireName:(NSString *)wireName
                             onClass:(Class)owner;

+ (instancetype)arrayElementForProperty:(NSString *)property
                               wireName:(NSString *)wireName
                              itemClass:(Class)itemClass
                                onClass:(Class)owner;

@end

NS_ASSUME_NONNULL_END
