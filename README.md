wsdl2objc
=========
Generates Objective-C (Cocoa) code from a WSDL for calling SOAP services


Export to GitHub
wsdl2objc - UsageInstructions.wiki
First steps
Generating code out of the WSDL file

Once you obtain WSDL2ObjC, code generation is pretty simple.

    Launch the app
    Browse to a WSDL file or enter in a URL
    Browse to an output directory
    Click "Parse WSDL"

Source code files will be added to the output directory you've specified.
There will be one pair of .h/.m files for each namespace in your WSDL.

Including the generated source files

You can add the output files to your project or create a web service framework from them.
Each project that uses the generated web service code will need to link against libxml2 by performing the following for each target in your XCode project:
    Get info on the target and go to the build tab
    Add "-lxml2" to the Other Linker Flags property
    Add "-I/usr/include/libxml2" to the Other C Flags property

If you are building an iPhone project also perform the following:
    Right click on the Frameworks folder in your project and select Add -> Existing Frameworks...
    Select the CFNetwork.framework appropriate for your iPhone build

Using the generated code
You can use a given web service as follows:

#import "MyWebService.h"

MyWebServiceBinding *binding = [MyWebService MyWebServiceBinding];
binding.logXMLInOut = YES;

ns1_MyOperationRequest *request = [[ns1_MyOperationRequest new] autorelease];
request.attribute = @"attributeValue";
request.element = [[ns1_MyElement new] autorelease];
request.element.value = @"elementValue"];
MyWebServiceBindingResponse *response = [binding myOperationUsingParameters:request];

NSArray *responseHeaders = response.headers;
NSArray *responseBodyParts = response.bodyParts;

for(id header in responseHeaders) {
  if([header isKindOfClass:[ns2_MyHeaderResponse class]]) {
    ns2_MyHeaderResponse *headerResponse = (ns2_MyHeaderResponse*)header;
    
    // ... Handle ns2_MyHeaderResponse ...
  }
}

for(id bodyPart in responseBodyParts) {
  if([bodyPart isKindOfClass:[ns2_MyBodyResponse class]]) {
    ns2_MyBodyResponse *body = (ns2_MyBodyResponse*)bodyPart;
    
    // ... Handle ns2_MyBodyResponse ...
  }
}

Example

Assume the following:
    A SOAP service called "Friends"
    A SOAP method called GetFavoriteColor that has a request attribute called Friend, and a response attribute called Color (i.e. you're asking it to return you the favorite color for a given a friend)
    All the methods in this service ask for basic HTTP authentication, using a username and password that you acquired from the user via text fields

- (IBAction)pressedRequestButton:(id)sender {
    FriendsBinding *bFriends = [[FriendsService FriendsBinding] retain];
    bFriends.logXMLInOut = YES;
    bFriends.authUsername = u.text; 
    bFriends.authPassword = p.text;       
    types_getFavoriteColorRequestType *cRequest = [[types_getFavoriteColorRequestType new] autorelease];
    cRequest.friend = @"Johnny";
    [bFriends getFavoriteColorAsyncUsingRequest:cRequest delegate:self];
}

- (void) operation:(FriendsBindingOperation *)operation completedWithResponse:(FriendsBindingResponse *)response {
    NSArray *responseHeaders = response.headers;
    NSArray *responseBodyParts = response.bodyParts;
    
    for(id header in responseHeaders) {
        // here do what you want with the headers, if there's anything of value in them
    }
    
    for(id bodyPart in responseBodyParts) {
        /****
         * SOAP Fault Error
         ****/
        if ([bodyPart isKindOfClass:[SOAPFault class]]) {
            // You can get the error like this:
            tV.text = ((SOAPFault *)bodyPart).simpleFaultString;
            continue;
        }
        
        /****
         * Get Favorite Color
         ****/      
        if([bodyPart isKindOfClass:[types_getFavoriteColorResponseType class]]) {
            types_getFavoriteColorResponseType *body = (types_getFavoriteColorResponseType*)bodyPart;
            // Now you can extract the color from the response
            q.text = body.color;
            continue;

        }

// ...

}

Advanced Options

The given example above covers basic authentication, as implemented in versions 0.6 and 0.7-pre1.
The code in trunk has changed to support some more advanced security options, including advanced authentication and SOAP Security.
To get a brief introduction to this features please follow this http://code.google.com/p/wsdl2objc/wiki/AdvancedOptions'>link.
NOTE

If a WSDL has defined a string type that has attributes, then wsdl2objc will map it to a generic NSObject with a property called "content" which will hold the actual string.
So if you want to use the string, you have to call object.content. If you want its attributes, they're also properties of the object.
The short reason for this is that Cocoa makes it very hard to subclass NSStrings.
