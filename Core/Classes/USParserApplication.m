/*
 Copyright (c) 2008 LightSPEED Technologies, Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "USParserApplication.h"
#import "USType.h"
#import "USAttribute.h"
#import "USSchema.h"

@implementation USParserApplication

@dynamic wsdlURL;
@dynamic outURL;

static NSURL *URLFromDefaults(NSString *key) {
    NSString *pathString = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (pathString.length == 0) return nil;
    if ([pathString characterAtIndex:0] == '/') {
        return [NSURL fileURLWithPath:pathString];
    }
    return [NSURL URLWithString:pathString];
}

- (NSURL *)wsdlURL { return URLFromDefaults(@"wsdlPath"); }
- (NSURL *)outURL  { return URLFromDefaults(@"outPath"); }

- (void)writeDebugInfoForWSDL:(USWSDL *)wsdl {
    if (!wsdl) {
        NSLog(@"No WSDL!!");
        return;
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"writeDebug"]) return;

    NSLog(@"Writing debug info to console...");
    for (USSchema *schema in wsdl.schemas) {
        NSLog(@"Schema: %@", [schema fullName]);
        for (USType *t in [schema types]) {
            if ([t isComplexType]) {
                NSLog(@"\tComplex type: %@", t.typeName);
                for (USAttribute *at in t.attributes) {
                    if ([at.type isSimpleType]) {
                        USType *st = at.type;
                        NSLog(@"\t\tSimple Type attribute: %@, type: %@ representation: %@, default: %@",
                              at.name, st.typeName, st.representationClass, at.attributeDefault);
                    } else {
                        USType *act = at.type;
                        NSString *baseClass = act.superClass ? act.superClass.typeName : @"No base";
                        NSLog(@"\t\tComplex type attribute: %@, type: %@, base: %@, default: %@",
                              at.name, act.typeName, baseClass, at.attributeDefault);
                    }
                }
            } else {
                NSLog(@"\tSimple type: %@, representation class: %@", t.typeName, t.representationClass);
                for (NSString *v in t.enumerationValues) {
                    NSLog(@"\t\t- %@", v);
                }
            }
        }
    }
}

@end
