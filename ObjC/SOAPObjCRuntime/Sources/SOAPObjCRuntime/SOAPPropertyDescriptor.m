#import "SOAPPropertyDescriptor.h"
#import <objc/runtime.h>

static Class SOAPClassForProperty(Class owner, NSString *property) {
    objc_property_t prop = class_getProperty(owner, property.UTF8String);
    if (prop == NULL) return nil;
    char *typeEncoding = property_copyAttributeValue(prop, "T");
    if (typeEncoding == NULL) return nil;
    NSString *encoding = [NSString stringWithUTF8String:typeEncoding];
    free(typeEncoding);
    // Object types are encoded `@"ClassName"`. Primitives (`i`, `d`, etc.)
    // shouldn't appear because SOAPModel properties are always object-typed.
    if (![encoding hasPrefix:@"@\""]) return nil;
    NSString *className = [encoding substringWithRange:NSMakeRange(2, encoding.length - 3)];
    // Strip lightweight generic information (e.g. `NSArray<NSString*>`).
    NSRange lt = [className rangeOfString:@"<"];
    if (lt.location != NSNotFound) {
        className = [className substringToIndex:lt.location];
    }
    return NSClassFromString(className);
}

@implementation SOAPPropertyDescriptor

- (instancetype)initWithProperty:(NSString *)property
                        wireName:(NSString *)wireName
                            kind:(SOAPPropertyKind)kind
                  propertyClass:(Class)propertyClass
                       itemClass:(Class)itemClass {
    if ((self = [super init])) {
        _propertyName = [property copy];
        _wireName = [wireName copy];
        _kind = kind;
        _propertyClass = propertyClass;
        _itemClass = itemClass;
    }
    return self;
}

+ (instancetype)elementForProperty:(NSString *)property
                          wireName:(NSString *)wireName
                           onClass:(Class)owner {
    return [[self alloc] initWithProperty:property
                                  wireName:wireName
                                      kind:SOAPPropertyKindElement
                            propertyClass:SOAPClassForProperty(owner, property)
                                 itemClass:nil];
}

+ (instancetype)attributeForProperty:(NSString *)property
                            wireName:(NSString *)wireName
                             onClass:(Class)owner {
    return [[self alloc] initWithProperty:property
                                  wireName:wireName
                                      kind:SOAPPropertyKindAttribute
                            propertyClass:SOAPClassForProperty(owner, property)
                                 itemClass:nil];
}

+ (instancetype)arrayElementForProperty:(NSString *)property
                               wireName:(NSString *)wireName
                              itemClass:(Class)itemClass
                                onClass:(Class)owner {
    return [[self alloc] initWithProperty:property
                                  wireName:wireName
                                      kind:SOAPPropertyKindElementArray
                            propertyClass:SOAPClassForProperty(owner, property)
                                 itemClass:itemClass];
}

@end
