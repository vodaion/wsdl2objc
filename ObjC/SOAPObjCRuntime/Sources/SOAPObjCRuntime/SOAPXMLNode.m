#import "SOAPXMLNode.h"
#import "SOAPError.h"

#pragma mark - tree builder

@interface SOAPTreeBuilder : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong, nullable) SOAPXMLNode *root;
@end

@implementation SOAPTreeBuilder {
    NSMutableArray *_frames;
}

- (instancetype)init {
    if ((self = [super init])) {
        _frames = [NSMutableArray array];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    NSMutableDictionary *frame = [@{
        @"name": elementName,
        @"attrs": attributeDict ?: @{},
        @"children": [NSMutableArray array],
        @"text": [NSMutableString string],
    } mutableCopy];
    if (namespaceURI != nil) frame[@"ns"] = namespaceURI;
    [_frames addObject:frame];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_frames.count == 0) return;
    NSMutableString *text = [_frames.lastObject objectForKey:@"text"];
    [text appendString:string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    NSMutableDictionary *frame = [_frames.lastObject mutableCopy];
    [_frames removeLastObject];
    NSString *trimmed = [[frame objectForKey:@"text"]
                          stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    SOAPXMLNode *node = [[SOAPXMLNode alloc] initWithLocalName:frame[@"name"]
                                                   namespaceURI:frame[@"ns"]
                                                     attributes:frame[@"attrs"]
                                                       children:frame[@"children"]
                                                    stringValue:trimmed.length ? trimmed : nil];
    if (_frames.count == 0) {
        self.root = node;
    } else {
        [[_frames.lastObject objectForKey:@"children"] addObject:node];
    }
}

@end

#pragma mark - SOAPXMLNode

@implementation SOAPXMLNode

- (instancetype)initWithLocalName:(NSString *)localName
                      namespaceURI:(NSString *)namespaceURI
                        attributes:(NSDictionary<NSString *,NSString *> *)attributes
                          children:(NSArray<SOAPXMLNode *> *)children
                       stringValue:(NSString *)stringValue {
    if ((self = [super init])) {
        _localName = [localName copy];
        _namespaceURI = [namespaceURI copy];
        _attributes = [attributes copy];
        _children = [children copy];
        _stringValue = [stringValue copy];
    }
    return self;
}

- (SOAPXMLNode *)firstChildNamed:(NSString *)name {
    for (SOAPXMLNode *c in self.children) {
        if ([c.localName isEqualToString:name] ||
            [c.localName hasSuffix:[@":" stringByAppendingString:name]]) {
            return c;
        }
    }
    return nil;
}

- (NSArray<SOAPXMLNode *> *)childrenNamed:(NSString *)name {
    NSMutableArray<SOAPXMLNode *> *out = [NSMutableArray array];
    for (SOAPXMLNode *c in self.children) {
        if ([c.localName isEqualToString:name] ||
            [c.localName hasSuffix:[@":" stringByAppendingString:name]]) {
            [out addObject:c];
        }
    }
    return out;
}

- (SOAPXMLNode *)descendantNamed:(NSString *)name {
    if ([self.localName isEqualToString:name]) return self;
    for (SOAPXMLNode *c in self.children) {
        SOAPXMLNode *hit = [c descendantNamed:name];
        if (hit) return hit;
    }
    return nil;
}

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

- (NSString *)serialize {
    NSMutableString *attrs = [NSMutableString string];
    NSArray *sortedKeys = [self.attributes.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *k in sortedKeys) {
        [attrs appendFormat:@" %@=\"%@\"", k, XMLEscape(self.attributes[k])];
    }
    if (self.children.count == 0) {
        NSString *text = self.stringValue ? XMLEscape(self.stringValue) : @"";
        if (text.length == 0) {
            return [NSString stringWithFormat:@"<%@%@/>", self.localName, attrs];
        }
        return [NSString stringWithFormat:@"<%@%@>%@</%@>", self.localName, attrs, text, self.localName];
    }
    NSMutableString *inner = [NSMutableString string];
    if (self.stringValue) [inner appendString:XMLEscape(self.stringValue)];
    for (SOAPXMLNode *c in self.children) [inner appendString:[c serialize]];
    return [NSString stringWithFormat:@"<%@%@>%@</%@>", self.localName, attrs, inner, self.localName];
}

+ (SOAPXMLNode *)parseData:(NSData *)data error:(NSError **)error {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.shouldProcessNamespaces = YES;
    parser.shouldReportNamespacePrefixes = NO;
    SOAPTreeBuilder *delegate = [SOAPTreeBuilder new];
    parser.delegate = delegate;
    if (![parser parse]) {
        if (error) {
            *error = [NSError errorWithDomain:SOAPErrorDomain
                                          code:SOAPErrorCodeDecoding
                                      userInfo:@{NSLocalizedDescriptionKey: parser.parserError.localizedDescription ?: @"XML parse failed"}];
        }
        return nil;
    }
    return delegate.root;
}

+ (SOAPXMLNode *)parseBodyFromData:(NSData *)data error:(NSError **)error {
    SOAPXMLNode *root = [self parseData:data error:error];
    if (root == nil) return nil;
    SOAPXMLNode *body = [root firstChildNamed:@"Body"] ?: [root descendantNamed:@"Body"];
    if (body == nil) {
        if (error) {
            *error = [NSError errorWithDomain:SOAPErrorDomain
                                          code:SOAPErrorCodeDecoding
                                      userInfo:@{NSLocalizedDescriptionKey: @"envelope has no <Body>"}];
        }
        return nil;
    }
    return body;
}

@end
