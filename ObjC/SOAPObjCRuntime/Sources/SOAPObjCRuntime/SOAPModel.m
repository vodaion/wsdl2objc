#import "SOAPModel.h"
#import "SOAPPropertyDescriptor.h"
#import "SOAPXMLNode.h"
#import "SOAPDateFormatter.h"
#import "SOAPError.h"
#import "SOAPFault.h"

static NSString *XMLEscape(NSString *s) {
    NSMutableString *r = [NSMutableString stringWithCapacity:s.length];
    NSUInteger len = s.length;
    for (NSUInteger i = 0; i < len; i++) {
        unichar c = [s characterAtIndex:i];
        switch (c) {
            case '&':  [r appendString:@"&amp;"];  break;
            case '<':  [r appendString:@"&lt;"];   break;
            case '>':  [r appendString:@"&gt;"];   break;
            case '"':  [r appendString:@"&quot;"]; break;
            case '\'': [r appendString:@"&apos;"]; break;
            default:   [r appendFormat:@"%C", c];
        }
    }
    return r;
}

#pragma mark - Primitive helpers

@interface SOAPPrimitiveCodec : NSObject
+ (BOOL)isPrimitiveClass:(Class)cls;
+ (NSString *)encodeValue:(id)value;
+ (id)decodeString:(NSString *)string toClass:(Class)cls;
@end

@implementation SOAPPrimitiveCodec

+ (BOOL)isPrimitiveClass:(Class)cls {
    if (cls == nil) return NO;
    return [cls isSubclassOfClass:[NSString class]]
        || [cls isSubclassOfClass:[NSNumber class]]
        || [cls isSubclassOfClass:[NSDecimalNumber class]]
        || [cls isSubclassOfClass:[NSDate class]]
        || [cls isSubclassOfClass:[NSData class]];
}

+ (NSString *)encodeValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        return XMLEscape(value);
    }
    if ([value isKindOfClass:[NSDate class]]) {
        return [SOAPDateFormatter stringFromDate:value];
    }
    if ([value isKindOfClass:[NSData class]]) {
        return [(NSData *)value base64EncodedStringWithOptions:0];
    }
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return [(NSDecimalNumber *)value stringValue];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *n = value;
        const char *type = n.objCType;
        if (strcmp(type, @encode(BOOL)) == 0 ||
            (strcmp(type, "c") == 0 && (n.charValue == 0 || n.charValue == 1))) {
            return n.boolValue ? @"true" : @"false";
        }
        return [n stringValue];
    }
    return XMLEscape([value description]);
}

+ (id)decodeString:(NSString *)string toClass:(Class)cls {
    if (string == nil) return nil;
    if ([cls isSubclassOfClass:[NSString class]]) {
        return string;
    }
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) {
        return [NSDecimalNumber decimalNumberWithString:string];
    }
    if ([cls isSubclassOfClass:[NSDate class]]) {
        return [SOAPDateFormatter dateFromString:string];
    }
    if ([cls isSubclassOfClass:[NSData class]]) {
        return [[NSData alloc] initWithBase64EncodedString:string options:0];
    }
    if ([cls isSubclassOfClass:[NSNumber class]]) {
        NSString *trimmed = [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        if ([trimmed caseInsensitiveCompare:@"true"] == NSOrderedSame) return @YES;
        if ([trimmed caseInsensitiveCompare:@"false"] == NSOrderedSame) return @NO;
        if ([trimmed rangeOfString:@"."].location != NSNotFound) {
            return @(trimmed.doubleValue);
        }
        return @(trimmed.longLongValue);
    }
    return nil;
}

@end

#pragma mark - SOAPModel

@implementation SOAPModel

+ (NSString *)soapNamespace { return @""; }
+ (NSString *)soapName { return NSStringFromClass(self); }
+ (NSArray<SOAPPropertyDescriptor *> *)soapProperties { return @[]; }

#pragma mark Encode

- (NSString *)encodeSOAPBody:(NSError **)error {
    return [self encodeSOAPBodyWithRootName:[[self class] soapName] error:error];
}

- (NSString *)encodeSOAPBodyWithRootName:(NSString *)rootName error:(NSError **)error {
    NSArray<SOAPPropertyDescriptor *> *props = [[self class] soapProperties];
    NSMutableString *attrs = [NSMutableString string];
    NSMutableString *children = [NSMutableString string];

    for (SOAPPropertyDescriptor *p in props) {
        id value = [self valueForKey:p.propertyName];
        if (value == nil || value == NSNull.null) continue;

        switch (p.kind) {
            case SOAPPropertyKindAttribute: {
                if ([SOAPPrimitiveCodec isPrimitiveClass:p.propertyClass]) {
                    [attrs appendFormat:@" %@=\"%@\"",
                        p.wireName, [SOAPPrimitiveCodec encodeValue:value]];
                }
                break;
            }
            case SOAPPropertyKindElement: {
                if ([p.propertyClass isSubclassOfClass:[SOAPModel class]]) {
                    NSError *e = nil;
                    NSString *part = [value encodeSOAPBodyWithRootName:p.wireName error:&e];
                    if (part == nil) {
                        if (error) *error = e;
                        return nil;
                    }
                    [children appendString:part];
                } else if ([SOAPPrimitiveCodec isPrimitiveClass:p.propertyClass]) {
                    [children appendFormat:@"<%@>%@</%@>",
                        p.wireName, [SOAPPrimitiveCodec encodeValue:value], p.wireName];
                }
                break;
            }
            case SOAPPropertyKindElementArray: {
                NSArray *items = value;
                for (id item in items) {
                    if ([p.itemClass isSubclassOfClass:[SOAPModel class]]) {
                        NSError *e = nil;
                        NSString *part = [item encodeSOAPBodyWithRootName:p.wireName error:&e];
                        if (part == nil) {
                            if (error) *error = e;
                            return nil;
                        }
                        [children appendString:part];
                    } else {
                        [children appendFormat:@"<%@>%@</%@>",
                            p.wireName, [SOAPPrimitiveCodec encodeValue:item], p.wireName];
                    }
                }
                break;
            }
        }
    }

    NSString *xmlnsAttr = @"";
    NSString *ns = [[self class] soapNamespace];
    if (ns.length > 0) {
        xmlnsAttr = [NSString stringWithFormat:@" xmlns=\"%@\"", ns];
    }
    return [NSString stringWithFormat:@"<%@%@%@>%@</%@>",
            rootName, xmlnsAttr, attrs, children, rootName];
}

#pragma mark Decode

+ (instancetype)decodeFromSOAPElement:(SOAPXMLNode *)node error:(NSError **)error {
    SOAPModel *instance = [[self alloc] init];
    if (instance == nil) return nil;

    for (SOAPPropertyDescriptor *p in [self soapProperties]) {
        switch (p.kind) {
            case SOAPPropertyKindAttribute: {
                NSString *raw = node.attributes[p.wireName];
                if (raw == nil) continue;
                id value = [SOAPPrimitiveCodec decodeString:raw toClass:p.propertyClass];
                if (value) [instance setValue:value forKey:p.propertyName];
                break;
            }
            case SOAPPropertyKindElement: {
                SOAPXMLNode *child = [node firstChildNamed:p.wireName];
                if (child == nil) continue;
                if ([p.propertyClass isSubclassOfClass:[SOAPModel class]]) {
                    NSError *e = nil;
                    id sub = [p.propertyClass decodeFromSOAPElement:child error:&e];
                    if (sub == nil) {
                        if (error) *error = e;
                        return nil;
                    }
                    [instance setValue:sub forKey:p.propertyName];
                } else {
                    id value = [SOAPPrimitiveCodec decodeString:child.stringValue toClass:p.propertyClass];
                    if (value) [instance setValue:value forKey:p.propertyName];
                }
                break;
            }
            case SOAPPropertyKindElementArray: {
                NSArray<SOAPXMLNode *> *matches = [node childrenNamed:p.wireName];
                NSMutableArray *items = [NSMutableArray arrayWithCapacity:matches.count];
                for (SOAPXMLNode *c in matches) {
                    if ([p.itemClass isSubclassOfClass:[SOAPModel class]]) {
                        NSError *e = nil;
                        id sub = [p.itemClass decodeFromSOAPElement:c error:&e];
                        if (sub == nil) {
                            if (error) *error = e;
                            return nil;
                        }
                        [items addObject:sub];
                    } else {
                        id value = [SOAPPrimitiveCodec decodeString:c.stringValue toClass:p.itemClass];
                        if (value) [items addObject:value];
                    }
                }
                [instance setValue:items forKey:p.propertyName];
                break;
            }
        }
    }
    return instance;
}

+ (instancetype)decodeSOAPResponse:(NSData *)data
                      operationName:(NSString *)operationName
                              error:(NSError **)error {
    SOAPXMLNode *body = [SOAPXMLNode parseBodyFromData:data error:error];
    if (body == nil) return nil;

    // Surface SOAP fault if present.
    SOAPXMLNode *fault = [body firstChildNamed:@"Fault"];
    if (fault) {
        NSString *code = [fault firstChildNamed:@"faultcode"].stringValue
            ?: [[fault firstChildNamed:@"Code"] firstChildNamed:@"Value"].stringValue
            ?: @"Unknown";
        NSString *reason = [fault firstChildNamed:@"faultstring"].stringValue
            ?: [[fault firstChildNamed:@"Reason"] firstChildNamed:@"Text"].stringValue
            ?: @"";
        SOAPFault *f = [[SOAPFault alloc] initWithCode:code
                                                  reason:reason
                                                  detail:[fault firstChildNamed:@"detail"].stringValue
                                              httpStatus:0];
        if (error) {
            *error = [NSError errorWithDomain:SOAPErrorDomain
                                          code:SOAPErrorCodeFault
                                      userInfo:@{NSLocalizedDescriptionKey: reason,
                                                 SOAPFaultKey: f}];
        }
        return nil;
    }

    SOAPXMLNode *root = [body firstChildNamed:[self soapName]]
                     ?: [body firstChildNamed:operationName]
                     ?: body.children.firstObject
                     ?: body;
    return [self decodeFromSOAPElement:root error:error];
}

@end
