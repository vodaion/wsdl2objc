#import "USSwiftEmitter.h"

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

@interface USSwiftEmitter ()

- (void)writeSchema:(USSchema *)schema;
- (BOOL)shouldEmitType:(USType *)type;

- (NSString *)swiftIdentifier:(NSString *)raw;
- (NSString *)swiftTypeName:(NSString *)raw;
- (NSString *)swiftPropertyName:(NSString *)raw;
- (NSString *)swiftTypeForXSDName:(NSString *)xsdName;
- (NSString *)swiftPrimitiveForRepresentation:(NSString *)repr;
- (NSString *)swiftTypeForType:(USType *)type;

- (void)appendType:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema;
- (void)appendEnum:(USType *)type to:(NSMutableString *)out;
- (void)appendStruct:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema;
- (void)appendService:(USService *)service to:(NSMutableString *)out;
- (void)appendOperation:(USOperation *)op to:(NSMutableString *)out;

@end

@implementation USSwiftEmitter

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
        NSLog(@"USSwiftEmitter: no WSDL");
        return NO;
    }
    // WSDLs that put a schema under `xmlns="..."` (default namespace) leave
    // the parsed USSchema with a nil/empty prefix. Mirror what USWriter does
    // for ObjC output: assign `ns1`, `ns2`, ... so every schema with content
    // gets a stable filename.
    NSInteger fallbackCounter = 1;
    NSMutableSet *usedPrefixes = [NSMutableSet set];
    for (USSchema *schema in wsdl.schemas) {
        if (schema.prefix.length > 0) [usedPrefixes addObject:schema.prefix];
    }
    for (USSchema *schema in wsdl.schemas) {
        if ([schema shouldNotWrite]) continue;
        if (schema.prefix == nil || [schema.prefix length] == 0) {
            NSString *generated;
            do {
                generated = [NSString stringWithFormat:@"ns%ld", (long)fallbackCounter++];
            } while ([usedPrefixes containsObject:generated]);
            [usedPrefixes addObject:generated];
            schema.prefix = generated;
        }
        [self writeSchema:schema];
    }
    return YES;
}

#pragma mark - Naming

- (NSString *)swiftIdentifier:(NSString *)raw {
    if (raw == nil) return @"";
    NSArray *parts = [raw componentsSeparatedByCharactersInSet:kIllegalClassCharactersSet];
    return [parts componentsJoinedByString:@""];
}

- (NSString *)swiftTypeName:(NSString *)raw {
    NSString *cleaned = [self swiftIdentifier:raw];
    if ([cleaned length] == 0) return cleaned;
    NSString *first = [[cleaned substringToIndex:1] uppercaseString];
    return [first stringByAppendingString:[cleaned substringFromIndex:1]];
}

- (NSString *)swiftPropertyName:(NSString *)raw {
    NSString *cleaned = [self swiftIdentifier:raw];
    if ([cleaned length] == 0) return cleaned;
    NSString *first = [[cleaned substringToIndex:1] lowercaseString];
    NSString *out = [first stringByAppendingString:[cleaned substringFromIndex:1]];

    static NSSet *kw = nil;
    if (!kw) {
        kw = [[NSSet alloc] initWithArray:@[
            @"class", @"struct", @"enum", @"protocol", @"func", @"var", @"let",
            @"if", @"else", @"return", @"in", @"as", @"is", @"try", @"throws",
            @"async", @"await", @"actor", @"public", @"private", @"internal",
            @"open", @"fileprivate", @"static", @"self", @"Self", @"init",
            @"default", @"switch", @"case", @"while", @"for", @"do", @"catch",
            @"throw", @"true", @"false", @"nil", @"break", @"continue", @"guard",
            @"defer", @"repeat", @"import", @"typealias", @"associatedtype",
            @"extension", @"final", @"lazy", @"weak", @"unowned", @"inout",
            @"operator", @"prefix", @"postfix", @"infix", @"where", @"any",
            @"some", @"each", @"Type"
        ]];
    }
    if ([kw containsObject:out]) {
        return [NSString stringWithFormat:@"`%@`", out];
    }
    return out;
}

#pragma mark - Type mapping

- (NSString *)swiftTypeForXSDName:(NSString *)xsdName {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
            @"string": @"String", @"normalizedString": @"String", @"token": @"String",
            @"language": @"String", @"Name": @"String", @"NCName": @"String",
            @"anyType": @"String", @"ID": @"String", @"ENTITY": @"String",
            @"IDREF": @"String", @"QName": @"String", @"anyURI": @"String",
            @"boolean": @"Bool",
            @"byte": @"Int", @"short": @"Int", @"int": @"Int",
            @"long": @"Int", @"integer": @"Int",
            @"nonNegativeInteger": @"Int", @"positiveInteger": @"Int",
            @"unsignedByte": @"UInt", @"unsignedShort": @"UInt",
            @"unsignedInt": @"UInt", @"unsignedLong": @"UInt",
            @"float": @"Float", @"double": @"Double",
            @"decimal": @"Decimal",
            @"dateTime": @"Date", @"date": @"Date", @"time": @"Date", @"duration": @"Date",
            @"base64Binary": @"Data",
        } retain];
    }
    return [map objectForKey:xsdName];
}

- (NSString *)swiftPrimitiveForRepresentation:(NSString *)repr {
    if (repr == nil || [repr length] == 0) return @"String";
    NSString *t = [repr stringByReplacingOccurrencesOfString:@" *" withString:@""];
    t = [t stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSDictionary *map = @{
        @"NSString": @"String",
        @"NSNumber": @"Double",
        @"NSDecimalNumber": @"Decimal",
        @"NSDate": @"Date",
        @"NSData": @"Data",
        @"USBoolean": @"Bool",
    };
    NSString *mapped = [map objectForKey:t];
    return mapped ?: t;
}

- (NSString *)swiftTypeForType:(USType *)type {
    if (!type) return @"String";
    if ([type isSimpleType]) {
        if ([type.enumerationValues count] > 0) {
            return [self swiftTypeName:type.typeName];
        }
        NSString *byXSD = [self swiftTypeForXSDName:type.typeName];
        if (byXSD) return byXSD;
        return [self swiftPrimitiveForRepresentation:type.representationClass];
    }
    return [self swiftTypeName:type.typeName];
}

#pragma mark - Schema emission

- (void)writeSchema:(USSchema *)schema {
    NSMutableString *body = [NSMutableString string];
    // Per-schema reset: a header type used in one schema's services should
    // only produce a conformance extension in that schema's output file.
    NSMutableSet *previousHeaderTypes = [[self.headerTypeNames retain] autorelease];
    self.headerTypeNames = [NSMutableSet set];

    for (USType *type in schema.types) {
        if (![self shouldEmitType:type]) continue;
        [self appendType:type to:body schema:schema];
        [body appendString:@"\n"];
    }

    for (USService *service in schema.services) {
        [self appendService:service to:body];
        [body appendString:@"\n"];
    }

    // After services are emitted, all header types used by operations in this
    // schema are collected. Emit a bare conformance extension per type — the
    // SOAPHeader default impl forwards to _encodeSOAPBody.
    if ([self.headerTypeNames count] > 0) {
        NSArray *sortedTypes = [[self.headerTypeNames allObjects] sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *typeName in sortedTypes) {
            [body appendFormat:@"extension %@: SOAPHeader {}\n", typeName];
        }
        [body appendString:@"\n"];
    }

    // Restore prior accumulator (in case schema iteration is ever nested).
    self.headerTypeNames = previousHeaderTypes;

    if ([body length] == 0) return;

    // Trim trailing whitespace so the file ends with exactly one newline.
    while ([body length] >= 2 &&
           [body characterAtIndex:[body length] - 1] == '\n' &&
           [body characterAtIndex:[body length] - 2] == '\n') {
        [body deleteCharactersInRange:NSMakeRange([body length] - 1, 1)];
    }

    NSMutableString *out = [NSMutableString string];
    [out appendString:@"// Generated from WSDL. Do not edit — regenerate with wsdl2objc.\n"];
    [out appendFormat:@"// namespace: %@\n\n", schema.fullName ?: @""];
    [out appendString:@"import Foundation\n"];
    [out appendString:@"import SOAPMacros\n\n"];
    [out appendString:body];

    NSString *filename = [NSString stringWithFormat:@"%@.swift", schema.prefix];
    NSURL *fileURL = [NSURL URLWithString:filename relativeToURL:outDir];
    NSError *err = nil;
    [out writeToURL:fileURL atomically:NO encoding:NSUTF8StringEncoding error:&err];
    if (err) {
        NSLog(@"USSwiftEmitter: error writing %@: %@", filename, err);
    }
}

- (BOOL)shouldEmitType:(USType *)type {
    if (!type || !type.hasBeenParsed) return NO;
    if (type.behavior == TypeBehavior_simple) {
        if ([type.enumerationValues count] > 0) return YES;
        if ([self swiftTypeForXSDName:type.typeName] != nil) return NO;
        if ([type.typeName isEqualToString:type.representationClass]) return NO;
        return YES;
    }
    return type.behavior == TypeBehavior_complex;
}

- (void)appendType:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema {
    if ([type isSimpleType]) {
        if ([type.enumerationValues count] > 0) {
            [self appendEnum:type to:out];
        } else {
            NSString *underlying = [self swiftPrimitiveForRepresentation:type.representationClass];
            [out appendFormat:@"public typealias %@ = %@\n",
                [self swiftTypeName:type.typeName], underlying];
        }
        return;
    }
    [self appendStruct:type to:out schema:schema];
}

- (void)appendEnum:(USType *)type to:(NSMutableString *)out {
    NSString *name = [self swiftTypeName:type.typeName];
    [out appendFormat:@"public enum %@: String, Codable, Sendable {\n", name];
    static NSCharacterSet *swiftIdHead = nil;
    if (!swiftIdHead) {
        NSMutableCharacterSet *set = [[NSCharacterSet letterCharacterSet] mutableCopy];
        [set addCharactersInString:@"_"];
        swiftIdHead = [set copy];
    }
    for (NSString *v in type.enumerationValues) {
        NSString *caseName = [self swiftPropertyName:v];
        // Swift case names must start with a letter or underscore; values like
        // "1" (legal in xs:restriction) become `_1` here.
        if (caseName.length == 0 ||
            ![swiftIdHead characterIsMember:[caseName characterAtIndex:0]]) {
            caseName = [@"_" stringByAppendingString:caseName];
        }
        [out appendFormat:@"    case %@ = \"%@\"\n", caseName, v];
    }
    [out appendString:@"}\n"];
}

- (NSArray *)flattenSequenceElementsForType:(USType *)type {
    NSMutableArray *all = [NSMutableArray array];
    NSMutableArray *chain = [NSMutableArray array];
    USType *cur = type.superClass;
    while (cur) {
        [chain insertObject:cur atIndex:0];
        cur = cur.superClass;
    }
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
    while (cur) {
        [chain insertObject:cur atIndex:0];
        cur = cur.superClass;
    }
    for (USType *t in chain) {
        for (USAttribute *a in t.attributes) [all addObject:a];
    }
    for (USAttribute *a in type.attributes) [all addObject:a];
    return all;
}

- (void)appendStruct:(USType *)type to:(NSMutableString *)out schema:(USSchema *)schema {
    NSString *swiftName = [self swiftTypeName:type.typeName];
    NSString *ns = schema.fullName ?: @"";

    [out appendFormat:@"@SOAPType(namespace: \"%@\", name: \"%@\")\n", ns, type.typeName];
    [out appendFormat:@"public struct %@ {\n", swiftName];

    NSArray *seqs = [self flattenSequenceElementsForType:type];
    NSArray *attrs = [self flattenAttributesForType:type];

    for (USSequenceElement *se in seqs) {
        // USParser+Types.m defaults absent minOccurs/maxOccurs attributes to 0,
        // but the XSD spec default is 1. The parser can't distinguish "absent"
        // from "explicit 0", so we normalize 0 -> 1 here. The unbounded sentinel
        // (-1) is preserved.
        NSInteger effMin = (se.minOccurs == 0) ? 1 : se.minOccurs;
        NSInteger effMax = (se.maxOccurs == 0) ? 1 : se.maxOccurs;

        NSString *swiftType = [self swiftTypeForType:se.type];
        BOOL isArray = (effMax == -1 || effMax > 1);
        BOOL isOptional = (effMin == 0);
        if (isArray) swiftType = [NSString stringWithFormat:@"[%@]", swiftType];
        else if (isOptional) swiftType = [swiftType stringByAppendingString:@"?"];

        NSMutableString *attrLine = [NSMutableString stringWithFormat:@"    @SOAPElement(name: \"%@\"",
            se.wsdlName ?: se.name];
        if (effMin != 1) [attrLine appendFormat:@", minOccurs: %ld", (long)effMin];
        if (effMax != 1) [attrLine appendFormat:@", maxOccurs: %ld", (long)effMax];
        [attrLine appendString:@")\n"];
        [out appendString:attrLine];
        [out appendFormat:@"    public var %@: %@\n\n",
            [self swiftPropertyName:se.name], swiftType];
    }

    for (USAttribute *attr in attrs) {
        NSString *swiftType = [self swiftTypeForType:attr.type];
        [out appendFormat:@"    @SOAPAttribute(name: \"%@\")\n", attr.wsdlName ?: attr.name];
        [out appendFormat:@"    public var %@: %@\n\n",
            [self swiftPropertyName:attr.name], swiftType];
    }

    // Memberwise init
    NSMutableArray *initParams = [NSMutableArray array];
    for (USSequenceElement *se in seqs) {
        NSInteger effMin = (se.minOccurs == 0) ? 1 : se.minOccurs;
        NSInteger effMax = (se.maxOccurs == 0) ? 1 : se.maxOccurs;

        NSString *swiftType = [self swiftTypeForType:se.type];
        BOOL isArray = (effMax == -1 || effMax > 1);
        BOOL isOptional = (effMin == 0);
        if (isArray) swiftType = [NSString stringWithFormat:@"[%@]", swiftType];
        else if (isOptional) swiftType = [swiftType stringByAppendingString:@"?"];

        NSString *p = [NSString stringWithFormat:@"%@: %@%@",
            [self swiftPropertyName:se.name], swiftType,
            (isOptional && !isArray) ? @" = nil" : (isArray ? @" = []" : @"")];
        [initParams addObject:p];
    }
    for (USAttribute *a in attrs) {
        NSString *p = [NSString stringWithFormat:@"%@: %@",
            [self swiftPropertyName:a.name],
            [self swiftTypeForType:a.type]];
        [initParams addObject:p];
    }

    [out appendFormat:@"    public init(%@) {\n", [initParams componentsJoinedByString:@", "]];
    for (USSequenceElement *se in seqs) {
        NSString *pn = [self swiftPropertyName:se.name];
        [out appendFormat:@"        self.%@ = %@\n", pn, pn];
    }
    for (USAttribute *a in attrs) {
        NSString *pn = [self swiftPropertyName:a.name];
        [out appendFormat:@"        self.%@ = %@\n", pn, pn];
    }
    [out appendString:@"    }\n"];
    [out appendString:@"}\n"];
}

#pragma mark - Service emission

- (NSString *)addressForService:(USService *)service {
    for (USPort *port in service.ports) {
        if (port.address && [port.address length] > 0) return port.address;
    }
    return @"";
}

- (NSString *)soapVersionForService:(USService *)service {
    // Pick the first port's binding version — when a service offers both
    // SOAP 1.1 and 1.2 the 1.1 port is conventionally listed first and is
    // the better default for clients (1.2 carries no real benefit here).
    USPort *first = [service.ports firstObject];
    if (first.binding.soapVersion && [first.binding.soapVersion isEqualToString:@"1.2"]) {
        return @".v1_2";
    }
    return @".v1_1";
}

- (void)appendService:(USService *)service to:(NSMutableString *)out {
    NSString *address = [self addressForService:service];
    NSString *version = [self soapVersionForService:service];
    // Avoid `ListenerServiceServiceService` when the WSDL service name
    // already ends in `Service`.
    NSString *baseName = service.name ?: @"";
    NSString *actorBase = [baseName hasSuffix:@"Service"]
        ? baseName
        : [NSString stringWithFormat:@"%@Service", baseName];
    NSString *actorName = [self swiftTypeName:actorBase];

    [out appendFormat:@"@SOAPService(endpoint: \"%@\", soapVersion: %@)\n", address, version];
    [out appendFormat:@"public actor %@ {\n", actorName];

    NSMutableSet *seen = [NSMutableSet set];
    NSMutableArray *ops = [NSMutableArray array];
    for (USPort *port in service.ports) {
        USPortType *pt = port.binding.portType;
        for (USOperation *op in pt.operations) {
            if ([seen containsObject:op.name]) continue;
            [seen addObject:op.name];
            [ops addObject:op];
        }
    }
    for (NSUInteger i = 0; i < [ops count]; i++) {
        [self appendOperation:[ops objectAtIndex:i] to:out];
        if (i + 1 < [ops count]) [out appendString:@"\n"];
    }
    [out appendString:@"}\n"];
}

- (USType *)outputTypeForOperation:(USOperation *)op {
    USPart *firstPart = [op.output.body.parts firstObject];
    return firstPart.element.type;
}

// Returns the operation's input body parts as an array of USPart, or empty
// if the operation takes no body. Each part contributes one Swift function
// parameter and one entry in @SOAPOperation's bodyWireNames.
- (NSArray *)inputBodyPartsForOperation:(USOperation *)op {
    return op.input.body.parts ?: @[];
}

- (NSString *)bodyNamespaceForOperation:(USOperation *)op {
    // All body parts in a single operation typically share a namespace; pick
    // the first part's schema if available, falling back to the portType's.
    USPart *firstPart = [op.input.body.parts firstObject];
    if (firstPart.element.schema.fullName) return firstPart.element.schema.fullName;
    return op.portType.schema.fullName ?: @"";
}

- (void)appendOperation:(USOperation *)op to:(NSMutableString *)out {
    NSString *opName = [self swiftPropertyName:op.name];
    NSString *soapAction = op.soapAction ?: @"";

    // ----- Body parts: one Swift parameter per <part> in the input message.
    NSArray *bodyParts = [self inputBodyPartsForOperation:op];
    NSMutableArray *bodyParamDecls = [NSMutableArray array];
    NSMutableArray *bodyWireNameLits = [NSMutableArray array];
    NSMutableSet *paramNameSeen = [NSMutableSet set];
    for (USPart *part in bodyParts) {
        USType *partType = part.element.type;
        if (!partType) continue;
        NSString *swiftType = [self swiftTypeForType:partType];
        NSString *paramName = [self swiftPropertyName:part.name];
        if ([paramName length] == 0) paramName = [self swiftPropertyName:part.element.name];
        // Disambiguate against earlier params and against later header params.
        NSString *unique = paramName;
        NSInteger suffix = 2;
        while ([paramNameSeen containsObject:unique]) {
            unique = [NSString stringWithFormat:@"%@%ld", paramName, (long)suffix++];
        }
        [paramNameSeen addObject:unique];

        NSString *wireName = part.element.wsdlName.length ? part.element.wsdlName : part.element.name;
        [bodyParamDecls addObject:[NSString stringWithFormat:@"%@: %@", unique, swiftType]];
        [bodyWireNameLits addObject:[NSString stringWithFormat:@"\"%@\"", wireName ?: @""]];
    }

    // ----- WSDL-declared input headers: one Swift parameter per header.
    NSMutableArray *headerParamNames = [NSMutableArray array];
    NSMutableArray *headerParamDecls = [NSMutableArray array];
    for (USElement *hElement in op.input.headers) {
        if (!hElement.type) continue;
        NSString *headerTypeSwift = [self swiftTypeName:hElement.type.typeName];
        NSString *paramName = [self swiftPropertyName:hElement.name];
        NSString *unique = paramName;
        NSInteger suffix = 2;
        while ([paramNameSeen containsObject:unique]) {
            unique = [NSString stringWithFormat:@"%@%ld", paramName, (long)suffix++];
        }
        [paramNameSeen addObject:unique];

        [headerParamNames addObject:[NSString stringWithFormat:@"\"%@\"", unique]];
        [headerParamDecls addObject:[NSString stringWithFormat:@"%@: %@", unique, headerTypeSwift]];
        [self.headerTypeNames addObject:headerTypeSwift];
    }

    // ----- @SOAPOperation macro line.
    NSMutableString *macroLine = [NSMutableString stringWithFormat:@"    @SOAPOperation(name: \"%@\", soapAction: \"%@\"",
        op.name, soapAction];
    if ([headerParamNames count] > 0) {
        [macroLine appendFormat:@", headerParams: [%@]", [headerParamNames componentsJoinedByString:@", "]];
    }
    if ([bodyWireNameLits count] > 0) {
        [macroLine appendFormat:@", bodyWireNames: [%@]", [bodyWireNameLits componentsJoinedByString:@", "]];
        NSString *ns = [self bodyNamespaceForOperation:op];
        if ([ns length] > 0) {
            [macroLine appendFormat:@", bodyNamespace: \"%@\"", ns];
        }
    }
    [macroLine appendString:@")\n"];
    [out appendString:macroLine];

    // ----- Function signature. Body params first, headers after.
    NSMutableArray *signatureParams = [NSMutableArray array];
    [signatureParams addObjectsFromArray:bodyParamDecls];
    [signatureParams addObjectsFromArray:headerParamDecls];

    // ----- Return type: Void when there's no output message or no output part.
    USType *outType = [self outputTypeForOperation:op];
    if (outType == nil) {
        [out appendFormat:@"    public func %@(%@) async throws\n",
            opName,
            [signatureParams componentsJoinedByString:@", "]];
    } else {
        NSString *outSwift = [self swiftTypeName:outType.typeName];
        [out appendFormat:@"    public func %@(%@) async throws -> %@\n",
            opName,
            [signatureParams componentsJoinedByString:@", "],
            outSwift];
    }
}

@end
