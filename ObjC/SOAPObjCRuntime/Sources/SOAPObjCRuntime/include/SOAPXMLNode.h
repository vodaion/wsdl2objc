#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Minimal in-memory XML tree used to navigate SOAP envelopes. Built from
/// NSXMLParser with namespace processing on, so `localName` is the
/// prefix-stripped tag name.
@interface SOAPXMLNode : NSObject

@property (nonatomic, copy, readonly) NSString *localName;
@property (nonatomic, copy, readonly, nullable) NSString *namespaceURI;
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *attributes;
@property (nonatomic, copy, readonly) NSArray<SOAPXMLNode *> *children;
@property (nonatomic, copy, readonly, nullable) NSString *stringValue;

- (instancetype)initWithLocalName:(NSString *)localName
                      namespaceURI:(nullable NSString *)namespaceURI
                        attributes:(NSDictionary<NSString *, NSString *> *)attributes
                          children:(NSArray<SOAPXMLNode *> *)children
                       stringValue:(nullable NSString *)stringValue
    NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

/// First child whose local name matches.
- (nullable SOAPXMLNode *)firstChildNamed:(NSString *)name;

/// All children whose local name matches.
- (NSArray<SOAPXMLNode *> *)childrenNamed:(NSString *)name;

/// Recursive descendant search by local name.
- (nullable SOAPXMLNode *)descendantNamed:(NSString *)name;

/// Re-emits this subtree as a standalone XML string.
- (NSString *)serialize;

+ (nullable SOAPXMLNode *)parseData:(NSData *)data error:(NSError **)error;

/// Parses an envelope and returns the `<soap:Body>` node.
+ (nullable SOAPXMLNode *)parseBodyFromData:(NSData *)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
