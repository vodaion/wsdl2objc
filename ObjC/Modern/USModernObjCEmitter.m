#import "USModernObjCEmitter.h"

#import "USWSDL.h"
#import "USSchema.h"
#import "USType.h"
#import "USAttribute.h"
#import "USElement.h"
#import "USSequenceElement.h"
#import "USService.h"
#import "USPort.h"
#import "USBinding.h"
#import "USPortType.h"
#import "USOperation.h"
#import "USOperationInterface.h"
#import "USMessage.h"
#import "USPart.h"
#import "USObjCKeywords.h"

@interface USModernObjCEmitter ()

- (void)writeSchema:(USSchema *)schema;
- (BOOL)shouldEmitType:(USType *)type;

- (NSString *)objcIdentifier:(NSString *)raw;
- (NSString *)objcTypeName:(NSString *)raw;
- (NSString *)objcPropertyName:(NSString *)raw;
- (NSString *)objcClassNameForType:(USType *)type;
- (BOOL)typeIsPrimitive:(USType *)type;
- (NSString *)objcPrimitivePropertyTypeForType:(USType *)type;

- (void)appendTypeForwardDecl:(USType *)type to:(NSMutableString *)out;
- (void)appendTypeInterface:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema;
- (void)appendTypeImplementation:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema;
- (void)appendEnumDeclaration:(USType *)type to:(NSMutableString *)out;
- (void)appendServiceInterface:(USService *)service to:(NSMutableString *)out;
- (void)appendServiceImplementation:(USService *)service to:(NSMutableString *)out;
- (void)appendOperationDeclaration:(USOperation *)op to:(NSMutableString *)out;
- (void)appendOperationImplementation:(USOperation *)op to:(NSMutableString *)out;

@end

@implementation USModernObjCEmitter

@synthesize wsdl;
@synthesize outDir;
@synthesize headerTypeNames;

- (id)initWithWSDL:(USWSDL *)aWSDL outputDirectory:(NSURL *)anOutDir {
    if ((self = [super init])) {
        self.wsdl = aWSDL;
        self.outDir = anOutDir;
        self.headerTypeNames = [NSMutableSet set];
    }
    return self;
}

- (void)dealloc {
    [wsdl release];
    [outDir release];
    [headerTypeNames release];
    [super dealloc];
}

- (BOOL)write {
    if (!wsdl) {
        NSLog(@"USModernObjCEmitter: no WSDL");
        return NO;
    }
    NSInteger fallback = 1;
    NSMutableSet *used = [NSMutableSet set];
    for (USSchema *schema in wsdl.schemas) {
        if (schema.prefix.length > 0) [used addObject:schema.prefix];
    }
    // First pass: assign fallback prefixes to all schemas that need one.
    // Required up-front so cross-schema #import detection in writeSchema can
    // see the right filename for sibling schemas regardless of write order.
    for (USSchema *schema in wsdl.schemas) {
        if ([schema shouldNotWrite]) continue;
        if (schema.prefix == nil || [schema.prefix length] == 0) {
            NSString *p;
            do { p = [NSString stringWithFormat:@"ns%ld", (long)fallback++]; }
            while ([used containsObject:p]);
            [used addObject:p];
            schema.prefix = p;
        }
    }
    // Second pass: emit files.
    for (USSchema *schema in wsdl.schemas) {
        if ([schema shouldNotWrite]) continue;
        [self writeSchema:schema];
    }
    return YES;
}

#pragma mark - Naming

- (NSString *)objcIdentifier:(NSString *)raw {
    if (raw == nil) return @"";
    NSArray *parts = [raw componentsSeparatedByCharactersInSet:kIllegalClassCharactersSet];
    return [parts componentsJoinedByString:@""];
}

- (NSString *)objcTypeName:(NSString *)raw {
    NSString *cleaned = [self objcIdentifier:raw];
    if ([cleaned length] == 0) return cleaned;
    NSString *first = [[cleaned substringToIndex:1] uppercaseString];
    return [first stringByAppendingString:[cleaned substringFromIndex:1]];
}

- (NSString *)objcPropertyName:(NSString *)raw {
    NSString *cleaned = [self objcIdentifier:raw];
    if ([cleaned length] == 0) return cleaned;
    NSString *first = [[cleaned substringToIndex:1] lowercaseString];
    NSString *out = [first stringByAppendingString:[cleaned substringFromIndex:1]];

    static NSSet *kw = nil;
    if (!kw) {
        kw = [[NSSet alloc] initWithArray:@[
            @"id", @"self", @"super", @"Class", @"new", @"alloc", @"copy",
            @"description", @"class", @"in", @"out", @"inout", @"bycopy",
            @"byref", @"oneway", @"_Bool", @"YES", @"NO", @"nil", @"NULL",
        ]];
    }
    if ([kw containsObject:out]) {
        return [out stringByAppendingString:@"_"];
    }
    return out;
}

#pragma mark - Type mapping

- (NSString *)objcPrimitiveForRepresentation:(NSString *)repr {
    if (repr.length == 0) return @"NSString *";
    NSString *t = [repr stringByReplacingOccurrencesOfString:@" *" withString:@""];
    t = [t stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSDictionary *map = @{
        @"NSString":        @"NSString *",
        @"NSNumber":        @"NSNumber *",
        @"NSDecimalNumber": @"NSDecimalNumber *",
        @"NSDate":          @"NSDate *",
        @"NSData":          @"NSData *",
        @"USBoolean":       @"NSNumber *",
    };
    NSString *mapped = [map objectForKey:t];
    return mapped ?: [NSString stringWithFormat:@"%@ *", t];
}

- (NSString *)objcPropertyTypeForXSDName:(NSString *)xsdName {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
            @"string": @"NSString *", @"normalizedString": @"NSString *",
            @"token": @"NSString *", @"language": @"NSString *",
            @"Name": @"NSString *", @"NCName": @"NSString *",
            @"anyType": @"NSString *", @"ID": @"NSString *",
            @"ENTITY": @"NSString *", @"IDREF": @"NSString *",
            @"QName": @"NSString *", @"anyURI": @"NSString *",
            @"boolean": @"NSNumber *",
            @"byte": @"NSNumber *", @"short": @"NSNumber *", @"int": @"NSNumber *",
            @"long": @"NSNumber *", @"integer": @"NSNumber *",
            @"nonNegativeInteger": @"NSNumber *", @"positiveInteger": @"NSNumber *",
            @"unsignedByte": @"NSNumber *", @"unsignedShort": @"NSNumber *",
            @"unsignedInt": @"NSNumber *", @"unsignedLong": @"NSNumber *",
            @"float": @"NSNumber *", @"double": @"NSNumber *",
            @"decimal": @"NSDecimalNumber *",
            @"dateTime": @"NSDate *", @"date": @"NSDate *",
            @"time": @"NSDate *", @"duration": @"NSDate *",
            @"base64Binary": @"NSData *",
        } retain];
    }
    return [map objectForKey:xsdName];
}

- (NSString *)objcPropertyTypeForType:(USType *)type {
    if (!type) return @"NSString *";
    if ([type isSimpleType]) {
        // Enum-restriction types travel as plain strings on the wire; the
        // generated `@interface FooEnum : NSObject` exposes class-method
        // constants for the allowed values, but the property itself stays
        // `NSString *` so Foundation reflection works cleanly.
        if ([type.enumerationValues count] > 0) {
            return @"NSString *";
        }
        NSString *byXSD = [self objcPropertyTypeForXSDName:type.typeName];
        if (byXSD) return byXSD;
        return [self objcPrimitiveForRepresentation:type.representationClass];
    }
    return [NSString stringWithFormat:@"%@ *", [self objcTypeName:type.typeName]];
}

- (BOOL)typeIsPrimitive:(USType *)type {
    if (!type) return YES;
    if ([type isSimpleType]) {
        if ([type.enumerationValues count] > 0) return NO;
        return YES;
    }
    return NO;
}

- (NSString *)objcClassNameForType:(USType *)type {
    if (!type) return @"";
    return [self objcTypeName:type.typeName];
}

#pragma mark - Schema emission

- (void)writeSchema:(USSchema *)schema {
    NSMutableString *header = [NSMutableString string];
    NSMutableString *impl = [NSMutableString string];

    NSMutableSet *previousHeaderTypes = [[self.headerTypeNames retain] autorelease];
    self.headerTypeNames = [NSMutableSet set];

    NSArray *typesToEmit = [schema.types filteredArrayUsingPredicate:
        [NSPredicate predicateWithBlock:^BOOL(USType *t, NSDictionary *bindings) {
            return [self shouldEmitType:t];
        }]];

    // Forward declarations so types can reference each other in any order.
    if (typesToEmit.count > 0) {
        NSMutableArray *fwd = [NSMutableArray array];
        for (USType *t in typesToEmit) {
            if (t.behavior == TypeBehavior_complex) {
                [fwd addObject:[self objcTypeName:t.typeName]];
            }
        }
        if (fwd.count > 0) {
            [header appendFormat:@"@class %@;\n\n", [fwd componentsJoinedByString:@", "]];
        }
    }

    for (USType *type in typesToEmit) {
        [self appendTypeInterface:type to:header schema:schema];
        [header appendString:@"\n"];
        [self appendTypeImplementation:type to:impl schema:schema];
        [impl appendString:@"\n"];
    }

    for (USService *service in schema.services) {
        [self appendServiceInterface:service to:header];
        [header appendString:@"\n"];
        [self appendServiceImplementation:service to:impl];
        [impl appendString:@"\n"];
    }

    if (self.headerTypeNames.count > 0) {
        NSArray *sorted = [self.headerTypeNames.allObjects sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *name in sorted) {
            [impl appendFormat:@"@interface %@ (SOAPHeaderAdoption) <SOAPHeader> @end\n", name];
            [impl appendFormat:@"@implementation %@ (SOAPHeaderAdoption) @end\n", name];
        }
        [impl appendString:@"\n"];
    }

    self.headerTypeNames = previousHeaderTypes;

    if (header.length == 0 && impl.length == 0) return;

    NSString *prefix = schema.prefix;
    NSString *baseName = [self objcTypeName:prefix];

    // Cross-schema #imports: when this schema's services reference types
    // declared in another schema, the .h needs to see those @interfaces.
    // Pragmatic approach: if this schema declares services but no types of
    // its own, import every other schema with types that we'll write a file
    // for. (Tracking the exact reference graph trips on `assign`-property
    // schema back-references that come back nil for anonymous types.)
    NSMutableSet *importedSchemas = [NSMutableSet set];
    BOOL thisSchemaHasServices = (schema.services.count > 0);
    if (thisSchemaHasServices) {
        for (USSchema *other in wsdl.schemas) {
            if (other == schema) continue;
            if ([other shouldNotWrite]) continue;
            if (other.prefix.length == 0) continue;
            BOOL hasEmittable = NO;
            for (USType *t in other.types) {
                if ([self shouldEmitType:t]) { hasEmittable = YES; break; }
            }
            if (!hasEmittable) continue;
            [importedSchemas addObject:other];
        }
    }
    NSMutableArray *importLines = [NSMutableArray array];
    NSArray *sortedSchemas = [importedSchemas.allObjects sortedArrayUsingComparator:^NSComparisonResult(USSchema *a, USSchema *b) {
        return [a.prefix compare:b.prefix];
    }];
    for (USSchema *s in sortedSchemas) {
        [importLines addObject:[NSString stringWithFormat:@"#import \"%@.h\"", [self objcTypeName:s.prefix]]];
    }

    NSMutableString *headerOut = [NSMutableString string];
    [headerOut appendString:@"// Generated from WSDL. Do not edit — regenerate with wsdl2objc.\n"];
    [headerOut appendFormat:@"// namespace: %@\n\n", schema.fullName ?: @""];
    [headerOut appendString:@"#import <Foundation/Foundation.h>\n"];
    [headerOut appendString:@"@import SOAPObjCRuntime;\n"];
    for (NSString *imp in importLines) [headerOut appendFormat:@"%@\n", imp];
    [headerOut appendString:@"\n"];
    [headerOut appendString:@"NS_ASSUME_NONNULL_BEGIN\n\n"];
    [headerOut appendString:header];
    [headerOut appendString:@"NS_ASSUME_NONNULL_END\n"];

    NSMutableString *implOut = [NSMutableString string];
    [implOut appendString:@"// Generated from WSDL. Do not edit — regenerate with wsdl2objc.\n"];
    [implOut appendFormat:@"// namespace: %@\n\n", schema.fullName ?: @""];
    [implOut appendFormat:@"#import \"%@.h\"\n\n", baseName];
    [implOut appendString:impl];

    NSError *err = nil;
    NSURL *hURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.h", baseName] relativeToURL:outDir];
    NSURL *mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.m", baseName] relativeToURL:outDir];
    [headerOut writeToURL:hURL atomically:NO encoding:NSUTF8StringEncoding error:&err];
    if (err) NSLog(@"emit error: %@", err);
    [implOut writeToURL:mURL atomically:NO encoding:NSUTF8StringEncoding error:&err];
    if (err) NSLog(@"emit error: %@", err);
}

- (BOOL)shouldEmitType:(USType *)type {
    if (!type || !type.hasBeenParsed) return NO;
    if (type.behavior == TypeBehavior_simple) {
        if ([type.enumerationValues count] > 0) return YES;
        if ([self objcPropertyTypeForXSDName:type.typeName] != nil) return NO;
        if ([type.typeName isEqualToString:type.representationClass]) return NO;
        return NO;   // typedef of a primitive — skip (ObjC has no typealias equivalent for object types)
    }
    return type.behavior == TypeBehavior_complex;
}

#pragma mark - Type emission

- (NSArray *)flattenSequenceElementsForType:(USType *)type {
    NSMutableArray *all = [NSMutableArray array];
    NSMutableArray *chain = [NSMutableArray array];
    USType *cur = type.superClass;
    while (cur) { [chain insertObject:cur atIndex:0]; cur = cur.superClass; }
    for (USType *t in chain) {
        for (USSequenceElement *se in t.sequenceElements) [all addObject:se];
    }
    for (USSequenceElement *se in type.sequenceElements) [all addObject:se];
    return all;
}

- (NSArray *)flattenAttributesForType:(USType *)type {
    NSMutableArray *all = [NSMutableArray array];
    NSMutableArray *chain = [NSMutableArray array];
    USType *cur = type.superClass;
    while (cur) { [chain insertObject:cur atIndex:0]; cur = cur.superClass; }
    for (USType *t in chain) {
        for (USAttribute *a in t.attributes) [all addObject:a];
    }
    for (USAttribute *a in type.attributes) [all addObject:a];
    return all;
}

- (void)appendTypeInterface:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema {
    if ([type isSimpleType]) {
        if ([type.enumerationValues count] > 0) {
            [self appendEnumDeclaration:type to:out];
        }
        return;
    }
    NSString *className = [self objcTypeName:type.typeName];
    [out appendFormat:@"@interface %@ : SOAPModel\n", className];

    NSArray *seqs = [self flattenSequenceElementsForType:type];
    NSArray *attrs = [self flattenAttributesForType:type];

    for (USSequenceElement *se in seqs) {
        NSInteger effMax = (se.maxOccurs == 0) ? 1 : se.maxOccurs;
        BOOL isArray = (effMax == -1 || effMax > 1);
        NSString *baseType = [self objcPropertyTypeForType:se.type];
        NSString *propType = isArray
            ? [NSString stringWithFormat:@"NSArray<%@> *", [baseType stringByReplacingOccurrencesOfString:@" *" withString:@" *>"]]
            : baseType;
        // Strip the stray ">" if base was already pointer-form; clean up:
        if (isArray) {
            // Build like NSArray<TypeName *> *
            NSString *trimmed = [baseType stringByReplacingOccurrencesOfString:@" *" withString:@""];
            propType = [NSString stringWithFormat:@"NSArray<%@ *> *", trimmed];
        }
        [out appendFormat:@"@property (nonatomic, strong, nullable) %@%@;\n",
            propType, [self objcPropertyName:se.name]];
    }
    for (USAttribute *attr in attrs) {
        [out appendFormat:@"@property (nonatomic, strong, nullable) %@%@;\n",
            [self objcPropertyTypeForType:attr.type], [self objcPropertyName:attr.name]];
    }
    [out appendString:@"@end\n"];
}

- (void)appendEnumDeclaration:(USType *)type to:(NSMutableString *)out {
    // Emit a namespace-style class with class methods returning the allowed
    // string values. The properties that USE this enum are typed as
    // `NSString *` (see `objcPropertyTypeForType:`).
    NSString *typeName = [self objcTypeName:type.typeName];
    [out appendFormat:@"@interface %@ : NSObject\n", typeName];
    for (NSString *v in type.enumerationValues) {
        NSString *upper = [[self objcIdentifier:v] uppercaseString];
        if (upper.length == 0 || ![[NSCharacterSet letterCharacterSet] characterIsMember:[upper characterAtIndex:0]]) {
            upper = [@"_" stringByAppendingString:upper];
        }
        [out appendFormat:@"+ (NSString *)%@; // %@\n",
            [self objcPropertyName:[NSString stringWithFormat:@"value_%@", upper]],
            v];
    }
    [out appendString:@"@end\n"];
}

- (void)appendTypeImplementation:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema {
    if ([type isSimpleType]) {
        if ([type.enumerationValues count] > 0) {
            NSString *typeName = [self objcTypeName:type.typeName];
            [out appendFormat:@"@implementation %@\n", typeName];
            for (NSString *v in type.enumerationValues) {
                NSString *upper = [[self objcIdentifier:v] uppercaseString];
                if (upper.length == 0 || ![[NSCharacterSet letterCharacterSet] characterIsMember:[upper characterAtIndex:0]]) {
                    upper = [@"_" stringByAppendingString:upper];
                }
                [out appendFormat:@"+ (NSString *)%@ { return @\"%@\"; }\n",
                    [self objcPropertyName:[NSString stringWithFormat:@"value_%@", upper]],
                    v];
            }
            [out appendString:@"@end\n"];
        }
        return;
    }
    NSString *className = [self objcTypeName:type.typeName];
    NSString *ns = schema.fullName ?: @"";

    [out appendFormat:@"@implementation %@\n", className];
    [out appendFormat:@"SOAP_TYPE_BEGIN(@\"%@\", @\"%@\")\n", ns, type.typeName];

    NSArray *seqs = [self flattenSequenceElementsForType:type];
    NSArray *attrs = [self flattenAttributesForType:type];
    NSMutableArray *lines = [NSMutableArray array];
    for (USSequenceElement *se in seqs) {
        NSInteger effMax = (se.maxOccurs == 0) ? 1 : se.maxOccurs;
        BOOL isArray = (effMax == -1 || effMax > 1);
        NSString *wire = se.wsdlName.length ? se.wsdlName : se.name;
        NSString *propName = [self objcPropertyName:se.name];
        if (isArray) {
            NSString *itemClass = [self objcTypeName:se.type.typeName];
            // For primitive items, use the Foundation class as the SOAPModel-subclass surrogate.
            if ([self typeIsPrimitive:se.type]) {
                NSString *bare = [[self objcPropertyTypeForType:se.type] stringByReplacingOccurrencesOfString:@" *" withString:@""];
                itemClass = bare;
            }
            [lines addObject:[NSString stringWithFormat:@"    SOAP_ELEMENT_ARRAY(%@, @\"%@\", %@)",
                propName, wire, itemClass]];
        } else {
            [lines addObject:[NSString stringWithFormat:@"    SOAP_ELEMENT(%@, @\"%@\")", propName, wire]];
        }
    }
    for (USAttribute *attr in attrs) {
        NSString *wire = attr.wsdlName.length ? attr.wsdlName : attr.name;
        [lines addObject:[NSString stringWithFormat:@"    SOAP_ATTRIBUTE(%@, @\"%@\")",
            [self objcPropertyName:attr.name], wire]];
    }
    [out appendString:[lines componentsJoinedByString:@",\n"]];
    if (lines.count > 0) [out appendString:@"\n"];
    [out appendString:@"SOAP_TYPE_END\n"];
    [out appendString:@"@end\n"];
}

#pragma mark - Service emission

- (NSString *)addressForService:(USService *)service {
    for (USPort *port in service.ports) {
        if (port.address.length) return port.address;
    }
    return @"";
}

- (NSString *)soapVersionForService:(USService *)service {
    USPort *first = [service.ports firstObject];
    if (first.binding.soapVersion && [first.binding.soapVersion isEqualToString:@"1.2"]) {
        return @"SOAPVersionV1_2";
    }
    return @"SOAPVersionV1_1";
}

- (NSString *)serviceClassNameFor:(USService *)service {
    NSString *base = service.name ?: @"";
    NSString *actorBase = [base hasSuffix:@"Service"] ? base : [base stringByAppendingString:@"Service"];
    return [self objcTypeName:actorBase];
}

- (NSArray *)inputBodyPartsForOperation:(USOperation *)op {
    return op.input.body.parts ?: @[];
}

- (NSString *)bodyNamespaceForOperation:(USOperation *)op {
    USPart *firstPart = [op.input.body.parts firstObject];
    if (firstPart.element.schema.fullName) return firstPart.element.schema.fullName;
    return op.portType.schema.fullName ?: @"";
}

- (USType *)outputTypeForOperation:(USOperation *)op {
    USPart *firstPart = [op.output.body.parts firstObject];
    return firstPart.element.type;
}

- (void)appendServiceInterface:(USService *)service to:(NSMutableString *)out {
    NSString *className = [self serviceClassNameFor:service];
    [out appendFormat:@"@interface %@ : SOAPService\n", className];
    NSMutableSet *seen = [NSMutableSet set];
    for (USPort *port in service.ports) {
        for (USOperation *op in port.binding.portType.operations) {
            if ([seen containsObject:op.name]) continue;
            [seen addObject:op.name];
            [self appendOperationDeclaration:op to:out];
        }
    }
    [out appendString:@"@end\n"];
}

- (void)appendServiceImplementation:(USService *)service to:(NSMutableString *)out {
    NSString *className = [self serviceClassNameFor:service];
    NSString *address = [self addressForService:service];
    NSString *version = [self soapVersionForService:service];
    [out appendFormat:@"@implementation %@\n", className];
    [out appendFormat:@"SOAP_SERVICE(@\"%@\", %@)\n\n", address, version];

    NSMutableSet *seen = [NSMutableSet set];
    NSMutableArray *ops = [NSMutableArray array];
    for (USPort *port in service.ports) {
        for (USOperation *op in port.binding.portType.operations) {
            if ([seen containsObject:op.name]) continue;
            [seen addObject:op.name];
            [ops addObject:op];
        }
    }
    for (USOperation *op in ops) {
        [self appendOperationImplementation:op to:out];
        [out appendString:@"\n"];
    }
    [out appendString:@"@end\n"];
}

- (void)appendOperationDeclaration:(USOperation *)op to:(NSMutableString *)out {
    NSString *methodBase = [self objcPropertyName:op.name];
    NSArray *bodyParts = [self inputBodyPartsForOperation:op];
    USType *outType = [self outputTypeForOperation:op];
    NSString *responsePropType = outType
        ? [NSString stringWithFormat:@"%@ * _Nullable", [self objcClassNameForType:outType]]
        : @"NSObject * _Nullable";

    // Build the selector. The first segment is `methodBase` + first part's
    // capitalized name; subsequent body parts get their own keyword.
    NSMutableString *sig = [NSMutableString string];
    [sig appendFormat:@"- (void)%@", methodBase];

    NSMutableSet *paramSeen = [NSMutableSet set];
    BOOL first = YES;
    for (USPart *part in bodyParts) {
        if (!part.element.type) continue;
        NSString *swiftLike = [self objcPropertyName:part.name];
        NSString *unique = swiftLike;
        NSInteger suf = 2;
        while ([paramSeen containsObject:unique]) {
            unique = [NSString stringWithFormat:@"%@%ld", swiftLike, (long)suf++];
        }
        [paramSeen addObject:unique];
        NSString *propType = [self objcPropertyTypeForType:part.element.type];
        NSString *keyword;
        if (first) {
            NSString *cap = unique.length
                ? [[[unique substringToIndex:1] uppercaseString] stringByAppendingString:[unique substringFromIndex:1]]
                : @"";
            keyword = [NSString stringWithFormat:@"With%@:(%@)%@", cap, propType, unique];
            first = NO;
        } else {
            keyword = [NSString stringWithFormat:@" %@:(%@)%@", unique, propType, unique];
        }
        [sig appendString:keyword];
    }

    for (USElement *hElement in op.input.headers) {
        if (!hElement.type) continue;
        NSString *headerTypeName = [self objcTypeName:hElement.type.typeName];
        NSString *paramName = [self objcPropertyName:hElement.name];
        NSString *unique = paramName;
        NSInteger suf = 2;
        while ([paramSeen containsObject:unique]) {
            unique = [NSString stringWithFormat:@"%@%ld", paramName, (long)suf++];
        }
        [paramSeen addObject:unique];
        [self.headerTypeNames addObject:headerTypeName];
        [sig appendFormat:@" %@:(%@ *)%@", unique, headerTypeName, unique];
    }

    [sig appendFormat:@"\n              completion:(void (^)(%@ response, NSError * _Nullable error))completion;\n",
        responsePropType];
    [out appendString:sig];
}

- (void)appendOperationImplementation:(USOperation *)op to:(NSMutableString *)out {
    NSString *methodBase = [self objcPropertyName:op.name];
    NSArray *bodyParts = [self inputBodyPartsForOperation:op];
    USType *outType = [self outputTypeForOperation:op];
    NSString *responsePropType = outType
        ? [NSString stringWithFormat:@"%@ * _Nullable", [self objcClassNameForType:outType]]
        : @"NSObject * _Nullable";
    NSString *soapAction = op.soapAction ?: @"";

    NSMutableString *sig = [NSMutableString string];
    [sig appendFormat:@"- (void)%@", methodBase];

    NSMutableArray *paramTuples = [NSMutableArray array];  // (paramName, type, isFirst)
    NSMutableSet *paramSeen = [NSMutableSet set];
    BOOL first = YES;
    for (USPart *part in bodyParts) {
        if (!part.element.type) continue;
        NSString *swiftLike = [self objcPropertyName:part.name];
        NSString *unique = swiftLike;
        NSInteger suf = 2;
        while ([paramSeen containsObject:unique]) {
            unique = [NSString stringWithFormat:@"%@%ld", swiftLike, (long)suf++];
        }
        [paramSeen addObject:unique];
        NSString *propType = [self objcPropertyTypeForType:part.element.type];
        NSString *wire = part.element.wsdlName.length ? part.element.wsdlName : part.element.name;
        if (first) {
            NSString *cap = unique.length
                ? [[[unique substringToIndex:1] uppercaseString] stringByAppendingString:[unique substringFromIndex:1]]
                : @"";
            [sig appendFormat:@"With%@:(%@)%@", cap, propType, unique];
            first = NO;
        } else {
            [sig appendFormat:@" %@:(%@)%@", unique, propType, unique];
        }
        [paramTuples addObject:@{@"name": unique, @"wire": wire}];
    }

    NSMutableArray *headerVars = [NSMutableArray array];
    for (USElement *hElement in op.input.headers) {
        if (!hElement.type) continue;
        NSString *headerTypeName = [self objcTypeName:hElement.type.typeName];
        NSString *paramName = [self objcPropertyName:hElement.name];
        NSString *unique = paramName;
        NSInteger suf = 2;
        while ([paramSeen containsObject:unique]) {
            unique = [NSString stringWithFormat:@"%@%ld", paramName, (long)suf++];
        }
        [paramSeen addObject:unique];
        [self.headerTypeNames addObject:headerTypeName];
        [sig appendFormat:@" %@:(%@ *)%@", unique, headerTypeName, unique];
        [headerVars addObject:unique];
    }

    [sig appendFormat:@"\n              completion:(void (^)(%@ response, NSError * _Nullable error))completion {\n",
        responsePropType];

    [out appendString:sig];

    NSString *responseClassExpr = outType
        ? [NSString stringWithFormat:@"%@.class", [self objcClassNameForType:outType]]
        : @"Nil";
    NSString *headersExpr = headerVars.count
        ? [NSString stringWithFormat:@"@[%@]", [[headerVars valueForKeyPath:@"description"] componentsJoinedByString:@", "]]
        : @"nil";

    if (paramTuples.count == 1) {
        NSDictionary *only = paramTuples.firstObject;
        [out appendFormat:@"    [self invokeOperation:@\"%@\"\n", op.name];
        [out appendFormat:@"                soapAction:@\"%@\"\n", soapAction];
        [out appendFormat:@"                   request:%@\n", only[@"name"]];
        [out appendFormat:@"             responseClass:%@\n", responseClassExpr];
        [out appendFormat:@"                   headers:%@\n", headersExpr];
        [out appendFormat:@"                completion:(void (^)(id, NSError *))completion];\n"];
    } else {
        NSString *ns = [self bodyNamespaceForOperation:op];
        NSMutableString *partsExpr = [NSMutableString stringWithString:@"@["];
        for (NSUInteger i = 0; i < paramTuples.count; i++) {
            NSDictionary *t = paramTuples[i];
            if (i > 0) [partsExpr appendString:@", "];
            [partsExpr appendFormat:@"@{@\"wireName\": @\"%@\", @\"payload\": %@}",
                t[@"wire"], t[@"name"]];
        }
        [partsExpr appendString:@"]"];
        [out appendFormat:@"    [self invokeOperation:@\"%@\"\n", op.name];
        [out appendFormat:@"                soapAction:@\"%@\"\n", soapAction];
        [out appendFormat:@"                 bodyParts:%@\n", partsExpr];
        [out appendFormat:@"             bodyNamespace:@\"%@\"\n", ns];
        [out appendFormat:@"             responseClass:%@\n", responseClassExpr];
        [out appendFormat:@"                   headers:%@\n", headersExpr];
        [out appendFormat:@"                completion:(void (^)(id, NSError *))completion];\n"];
    }
    [out appendString:@"}\n"];
}

@end
