// Umbrella header for the SOAPObjCRuntime framework.
//
// Mirrors the surface of Swift/SOAPMacros for ObjC consumers:
//   - SOAPClient: NSURLSession-based async SOAP client (completion blocks,
//     bridged to Swift `async` via NS_SWIFT_ASYNC).
//   - SOAPModel: base class for generated payload types.
//   - Preprocessor macros (SOAPMacros.h) replace the role of Swift macros —
//     each macro expands into the metadata methods the runtime introspects
//     at encode/decode time.
//   - Wire helpers: SOAPEnvelope, SOAPHeader, SOAPFault, SOAPXMLNode,
//     SOAPDateFormatter.

#import "SOAPVersion.h"
#import "SOAPError.h"
#import "SOAPMacros.h"
#import "SOAPPropertyDescriptor.h"
#import "SOAPModel.h"
#import "SOAPHeader.h"
#import "SOAPClient.h"
#import "SOAPService.h"
#import "SOAPEnvelope.h"
#import "SOAPFault.h"
#import "SOAPXMLNode.h"
#import "SOAPDateFormatter.h"
