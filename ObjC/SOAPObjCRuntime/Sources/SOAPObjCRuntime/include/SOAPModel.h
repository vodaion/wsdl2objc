#import <Foundation/Foundation.h>
@class SOAPPropertyDescriptor;
@class SOAPXMLNode;

NS_ASSUME_NONNULL_BEGIN

/// Base class for SOAP body / header payload types. Subclasses declare their
/// SOAP metadata via the macros in SOAPMacros.h. The base implementation
/// uses runtime reflection to encode/decode against the declared properties.
@interface SOAPModel : NSObject

/// Override via `SOAP_TYPE_BEGIN(...)`.
+ (NSString *)soapNamespace;
+ (NSString *)soapName;
+ (NSArray<SOAPPropertyDescriptor *> *)soapProperties;

/// Encodes the receiver as a standalone XML element fragment whose root tag
/// is `[[self class] soapName]`. Used by single-part SOAP body operations.
- (NSString *)encodeSOAPBody:(NSError **)error;

/// Same, with a caller-chosen root element name. Used by multi-part SOAP
/// body messages where the wire element name differs from the type name.
- (NSString *)encodeSOAPBodyWithRootName:(NSString *)rootName
                                   error:(NSError **)error;

/// Decodes an instance of the receiver class from a parsed SOAP XML node.
+ (nullable instancetype)decodeFromSOAPElement:(SOAPXMLNode *)node
                                          error:(NSError **)error;

/// Walks a parsed SOAP envelope and decodes the body's response element.
/// Looks for a child named `[self soapName]` first, falls back to the
/// operation name.
+ (nullable instancetype)decodeSOAPResponse:(NSData *)data
                              operationName:(NSString *)operationName
                                      error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
