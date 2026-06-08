#ifndef SOAPMacros_h
#define SOAPMacros_h

// Preprocessor macros that play the same role as Swift's `@SOAPType` /
// `@SOAPService` / `@SOAPOperation`: they collapse declarations and metadata
// into a single block at the call site. The runtime reads the emitted
// methods via class introspection.

/// Inside @implementation, declares the SOAP type's namespace + wire name and
/// opens the property-descriptor list. Close with `SOAP_TYPE_END`.
///
///   @implementation MyType
///   SOAP_TYPE_BEGIN(@"urn:example", @"MyType")
///       SOAP_ELEMENT(foo, @"foo"),
///       SOAP_ATTRIBUTE(id, @"id"),
///   SOAP_TYPE_END
///   @end
#define SOAP_TYPE_BEGIN(NS, NAME) \
    + (NSString *)soapNamespace { return (NS); } \
    + (NSString *)soapName { return (NAME); } \
    + (NSArray<SOAPPropertyDescriptor *> *)soapProperties { \
        return @[

#define SOAP_TYPE_END \
        ]; \
    }

// Avoid naming macro parameters after selector keywords — they get
// substituted inside `wireName:` and produce mangled selectors. The local
// names below (`_PROP_`, `_WIRE_`, `_CLS_`) are deliberately ugly so they
// never collide with anything in the wider selector vocabulary.

/// Marks a property as a child element with the given wire name.
#define SOAP_ELEMENT(_PROP_, _WIRE_) \
    [SOAPPropertyDescriptor elementForProperty:@#_PROP_ wireName:(_WIRE_) onClass:self]

/// Marks a property as an XML attribute.
#define SOAP_ATTRIBUTE(_PROP_, _WIRE_) \
    [SOAPPropertyDescriptor attributeForProperty:@#_PROP_ wireName:(_WIRE_) onClass:self]

/// Marks an `NSArray<ItemClass *> *` property as a repeated child element.
/// Lightweight generic info is stripped at runtime, so the item class must be
/// passed explicitly.
#define SOAP_ELEMENT_ARRAY(_PROP_, _WIRE_, _CLS_) \
    [SOAPPropertyDescriptor arrayElementForProperty:@#_PROP_ wireName:(_WIRE_) itemClass:[_CLS_ class] onClass:self]

/// Inside @implementation of a SOAPService subclass, declares the service
/// endpoint and SOAP version. Open with this; no closing macro needed.
#define SOAP_SERVICE(ENDPOINT_URL_STRING, SOAP_VERSION) \
    + (NSURL *)soapEndpointURL { return [NSURL URLWithString:(ENDPOINT_URL_STRING)]; } \
    + (SOAPVersion)soapVersion { return (SOAP_VERSION); }

#endif /* SOAPMacros_h */
