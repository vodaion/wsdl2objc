/*
 Copyright (c) 2010 LightSPEED Technologies, Inc.

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

#import <Foundation/Foundation.h>
#import "USParser.h"
#import "USWSDL.h"
#import "USParserApplication.h"
#import "USSwiftEmitter.h"
#import "USModernObjCEmitter.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool   *localAP = [NSAutoreleasePool new];
    USParserApplication *parserApp = [USParserApplication new];

    if (parserApp.wsdlURL == nil) {
        fprintf(stderr,
            "Usage: %s -wsdlPath <url or path> [-outPath <path>] [-language swift|objc-modern] [-writeDebug YES|NO]\n"
            "Generates Swift or modern Objective-C SOAP client code from a WSDL.\n"
            "    -wsdlPath <url or path>\tURL or path to a WSDL file\n"
            "    -outPath <path>\t\tDirectory output path. Defaults to current working directory.\n"
            "    -language <swift|objc-modern>\tEmit Swift (via SOAPMacros) or modern ObjC (via SOAPObjCRuntime). Defaults to swift.\n"
            "    -writeDebug <YES|NO>\tWrite debug info for the parsed WSDL. Defaults to NO.\n",
            argv[0]);
        [parserApp release];
        [localAP drain];
        exit(1);
    }
    if (parserApp.outURL == nil) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:
            @{@"outPath": [[NSFileManager defaultManager] currentDirectoryPath]}];
    }

    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
    if (language.length == 0) language = @"swift";

    BOOL emitSwift      = [language isEqualToString:@"swift"];
    BOOL emitObjCModern = [language isEqualToString:@"objc-modern"];
    if (!emitSwift && !emitObjCModern) {
        fprintf(stderr, "Unknown -language value '%s'. Use swift or objc-modern.\n", language.UTF8String);
        [parserApp release];
        [localAP drain];
        exit(1);
    }

    NSLog(@"Parsing WSDL file...");
    USParser *parser = [[USParser alloc] initWithURL:parserApp.wsdlURL];
    USWSDL *wsdl = [parser parse];
    [parserApp writeDebugInfoForWSDL:wsdl];
    [parser release];

    if (emitSwift) {
        NSLog(@"Generating Swift code into the output directory...");
        USSwiftEmitter *emitter = [[USSwiftEmitter alloc] initWithWSDL:wsdl outputDirectory:parserApp.outURL];
        [emitter write];
        [emitter release];
    }
    if (emitObjCModern) {
        NSLog(@"Generating modern Objective-C code into the output directory...");
        USModernObjCEmitter *emitter = [[USModernObjCEmitter alloc] initWithWSDL:wsdl outputDirectory:parserApp.outURL];
        [emitter write];
        [emitter release];
    }

    NSLog(@"Finished!");

    [parserApp release];
    [localAP drain];
    return 0;
}
