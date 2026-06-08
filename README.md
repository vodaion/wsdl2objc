# wsdl2objc

Generate modern Swift or modern Objective-C SOAP clients from a WSDL.

Two output paths share one parser:

- **Swift** — `@SOAPType` / `@SOAPService` / `@SOAPOperation` macros expand at compile time. `async throws` API. Codable + [XMLCoder](https://github.com/CoreOffice/XMLCoder) on the wire.
- **Objective-C** — preprocessor macros (`SOAP_TYPE_BEGIN`, `SOAP_ELEMENT`, `SOAP_SERVICE`) + runtime property reflection. Completion-block API, bridged to Swift `async` via `NS_SWIFT_ASYNC`.

Both stacks use `NSURLSession`, share an `xs:date` / `xs:dateTime` decoder that accepts 9 wire formats, and have been validated against three live public services (TemperatureConversions, CountryInfo, EU VIES VAT).

---

## Project layout

```
/
├── main.m                   CLI entry — parses -wsdlPath, -outPath, -language
├── Makefile                 build the CLI + drive both round-trips
├── Core/                    shared WSDL parser + schema model (ObjC, MRR)
├── Swift/
│   ├── USSwiftEmitter.{h,m}   the Swift emitter
│   ├── Samples/                5 WSDL fixtures
│   └── SOAPMacros/             SwiftPM package consumed by generated Swift
└── ObjC/
    ├── Modern/USModernObjCEmitter.{h,m}    the ObjC emitter
    └── SOAPObjCRuntime/                     SwiftPM package consumed by generated ObjC
```

Both `SOAPMacros` and `SOAPObjCRuntime` are standalone SwiftPM packages. You can consume them in any Xcode project without bringing the codegen tool with you.

---

## Quick start

### 1. Build the codegen tool

```bash
make
```

Produces `build/wsdl2objc`. Requires a current Xcode (Swift 6.x); the parser is ObjC MRR but the SwiftPM packages are Swift.

### 2. Generate Swift from a WSDL

```bash
build/wsdl2objc \
    -wsdlPath /absolute/path/to/your.wsdl \
    -outPath  /absolute/path/to/output \
    -language swift
```

Produces one `.swift` file per schema. Each file is just type declarations + macro annotations — no envelope code, no transport, no XML.

### 3. Generate modern Objective-C from a WSDL

```bash
build/wsdl2objc \
    -wsdlPath /absolute/path/to/your.wsdl \
    -outPath  /absolute/path/to/output \
    -language objc-modern
```

Produces a `.h`/`.m` pair per schema. Cross-schema `#import`s are added automatically.

### 4. Consume the output

Add `Swift/SOAPMacros` or `ObjC/SOAPObjCRuntime` as a SwiftPM dependency, drop the generated files into your target, and call the generated service methods.

---

## CLI reference

```
wsdl2objc -wsdlPath <url or path>
          [-outPath  <path>]
          [-language swift | objc-modern]
          [-writeDebug YES | NO]
```

| Flag | Default | Meaning |
| --- | --- | --- |
| `-wsdlPath` | (required) | URL (`http://...`) or absolute filesystem path to a WSDL file. Paths must start with `/` to be treated as files. |
| `-outPath` | current working directory | Directory where generated files are written. |
| `-language` | `swift` | `swift` emits `.swift` files for the `SOAPMacros` package; `objc-modern` emits `.h`/`.m` files for the `SOAPObjCRuntime` package. |
| `-writeDebug` | `NO` | Dump the parsed schema graph to stderr after parsing. |

Paths must be absolute. The CLI uses `NSUserDefaults` to read its arguments, which means a leading `/` is required for file paths or it will be interpreted as a URL.

---

## Swift package — `SOAPMacros`

### Add to your project

```swift
.package(path: "../wsdl2objc/Swift/SOAPMacros"),
// or
.package(url: "https://your-fork/wsdl2objc.git", from: "0.1.0"),
```

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "SOAPMacros", package: "SOAPMacros"),
    ]
),
```

Swift 6 toolchain required. The package enables the `BodyMacros` experimental feature for the operation macro.

### What the emitter generates

For `Swift/Samples/TemperatureConversions/TemperatureConversions.wsdl`:

```swift
import Foundation
import SOAPMacros

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "CelsiusToFahrenheit")
public struct CelsiusToFahrenheit {
    @SOAPElement(name: "nCelsius")
    public var nCelsius: Decimal

    public init(nCelsius: Decimal) {
        self.nCelsius = nCelsius
    }
}

@SOAPType(namespace: "http://webservices.daehosting.com/temperature", name: "CelsiusToFahrenheitResponse")
public struct CelsiusToFahrenheitResponse {
    @SOAPElement(name: "CelsiusToFahrenheitResult")
    public var celsiusToFahrenheitResult: Decimal
    // ...
}

@SOAPService(endpoint: "http://webservices.daehosting.com/services/TemperatureConversions.wso", soapVersion: .v1_1)
public actor TemperatureConversionsService {
    @SOAPOperation(name: "CelsiusToFahrenheit", soapAction: "")
    public func celsiusToFahrenheit(parameters: CelsiusToFahrenheit) async throws -> CelsiusToFahrenheitResponse
}
```

### Call site

```swift
import SOAPMacros

let service = TemperatureConversionsService()
let response = try await service.celsiusToFahrenheit(
    parameters: CelsiusToFahrenheit(nCelsius: 100)
)
print("\(response.celsiusToFahrenheitResult)")  // 212
```

The actor handles thread-safety; the macro-generated body wires up the envelope, dispatches via `URLSession`, and decodes the response — no boilerplate at the call site.

### Macro reference

| Macro | Where | What it does |
| --- | --- | --- |
| `@SOAPType(namespace:, name:)` | `struct` | Adds `_soapNamespace`/`_soapName` metadata + `CodingKeys` enum + `SOAPCodable` (`Codable + Sendable`) conformance. If any property has `@SOAPAttribute`, also adds `DynamicNodeEncoding` / `DynamicNodeDecoding`. |
| `@SOAPService(endpoint:, soapVersion:)` | `actor` | Injects `client: SOAPClient` and a designated init accepting `URLSession` / `SOAPAuthProvider` / `SOAPHeaderProvider`. |
| `@SOAPOperation(name:, soapAction:, headerParams:, bodyWireNames:, bodyNamespace:)` | `func` inside an `@SOAPService` actor | Body macro. Replaces the body with envelope construction → dispatch → response decode. |
| `@SOAPElement(name:, namespace:, minOccurs:, maxOccurs:, nillable:)` | stored property | Marker — read by `@SOAPType` at expansion. Property is rendered as a child element. |
| `@SOAPAttribute(name:, namespace:)` | stored property | Marker — property is rendered as an XML attribute. |

### Adding headers (e.g. WS-Security UsernameToken)

```swift
let provider = FixedHeaderProvider([
    WSSEUsernameToken(username: "admin", password: "secret")
])
let service = TemperatureConversionsService(headerProvider: provider)
```

Custom typed headers — any `SOAPCodable` struct can opt in via bare conformance:

```swift
@SOAPType(namespace: "urn:session", name: "SessionHeader")
public struct SessionHeader {
    @SOAPElement(name: "token") public var token: String
}
extension SessionHeader: SOAPHeader {}
```

WSDL-declared input headers — the emitter generates a header parameter automatically:

```swift
@SOAPOperation(name: "Echo", soapAction: "...", headerParams: ["sessionHeader"])
public func echo(parameters: EchoRequest, sessionHeader: SessionHeader) async throws -> EchoResponse
```

### Error handling

`SOAPFault` is thrown as a typed error:

```swift
do {
    let response = try await service.foo(parameters: ...)
} catch let fault as SOAPFault {
    print("\(fault.code): \(fault.reason)")
} catch {
    print("Transport error: \(error)")
}
```

### Tests + demos

```bash
cd Swift/SOAPMacros
swift test                                    # 22 tests
swift run TemperatureConversionsDemo          # live: 100°C = 212°F
swift run CountryInfoDemo                     # live: 6 continents
swift run VIESDemo                            # live: VAT lookup + xs:date
```

---

## Objective-C package — `SOAPObjCRuntime`

### Add to your project

```swift
.package(path: "../wsdl2objc/ObjC/SOAPObjCRuntime"),
```

```swift
.target(
    name: "MyApp",
    dependencies: ["SOAPObjCRuntime"]
),
```

ObjC consumers import the Clang module: `@import SOAPObjCRuntime;`

### What the emitter generates

For the same TemperatureConversions WSDL:

```objc
// TemperatureConversions.h
#import <Foundation/Foundation.h>
@import SOAPObjCRuntime;

NS_ASSUME_NONNULL_BEGIN

@interface CelsiusToFahrenheit : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *nCelsius;
@end

@interface CelsiusToFahrenheitResponse : SOAPModel
@property (nonatomic, strong, nullable) NSDecimalNumber *celsiusToFahrenheitResult;
@end

@interface TemperatureConversionsService : SOAPService
- (void)celsiusToFahrenheitWithParameters:(CelsiusToFahrenheit *)parameters
              completion:(void (^)(CelsiusToFahrenheitResponse * _Nullable response,
                                   NSError * _Nullable error))completion
    NS_SWIFT_ASYNC_NAME(celsiusToFahrenheit(parameters:));
@end

NS_ASSUME_NONNULL_END
```

```objc
// TemperatureConversions.m
#import "TemperatureConversions.h"

@implementation CelsiusToFahrenheit
SOAP_TYPE_BEGIN(@"http://webservices.daehosting.com/temperature", @"CelsiusToFahrenheit")
    SOAP_ELEMENT(nCelsius, @"nCelsius")
SOAP_TYPE_END
@end

@implementation TemperatureConversionsService
SOAP_SERVICE(@"http://webservices.daehosting.com/services/TemperatureConversions.wso", SOAPVersionV1_1)

- (void)celsiusToFahrenheitWithParameters:(CelsiusToFahrenheit *)parameters
              completion:(void (^)(CelsiusToFahrenheitResponse * _Nullable, NSError * _Nullable))completion {
    [self invokeOperation:@"CelsiusToFahrenheit" soapAction:@""
                   request:parameters responseClass:CelsiusToFahrenheitResponse.class
                   headers:nil completion:(void (^)(id, NSError *))completion];
}
@end
```

### Call site — ObjC

```objc
#import "TemperatureConversions.h"

TemperatureConversionsService *service = [TemperatureConversionsService new];

CelsiusToFahrenheit *request = [CelsiusToFahrenheit new];
request.nCelsius = [NSDecimalNumber decimalNumberWithString:@"100"];

[service celsiusToFahrenheitWithParameters:request
                                 completion:^(CelsiusToFahrenheitResponse *response, NSError *error) {
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@°F", response.celsiusToFahrenheitResult);
    }
}];
```

### Call site — Swift consuming the ObjC module

`NS_SWIFT_ASYNC_NAME` makes the completion-block method available as `async throws` in Swift:

```swift
import SOAPObjCRuntime

let service = TemperatureConversionsService()
let request = CelsiusToFahrenheit()
request.nCelsius = NSDecimalNumber(string: "100")
let response = try await service.celsiusToFahrenheit(parameters: request)
print("\(response.celsiusToFahrenheitResult!)°F")
```

### Macro reference (ObjC)

| Macro | Where | Expansion |
| --- | --- | --- |
| `SOAP_TYPE_BEGIN(ns, name)` … `SOAP_TYPE_END` | inside `@implementation` of a `SOAPModel` subclass | Adds `+soapNamespace`, `+soapName`, and a `+soapProperties` array of descriptors. |
| `SOAP_ELEMENT(prop, wireName)` | inside the BEGIN/END block | Property maps to a child element. |
| `SOAP_ATTRIBUTE(prop, wireName)` | inside the BEGIN/END block | Property maps to an XML attribute. |
| `SOAP_ELEMENT_ARRAY(prop, wireName, ItemClass)` | inside the BEGIN/END block | `NSArray<ItemClass *> *` maps to a repeated child element. Item class is explicit (Swift-style generics get stripped at runtime). |
| `SOAP_SERVICE(endpointString, version)` | inside `@implementation` of a `SOAPService` subclass | Adds `+soapEndpointURL` and `+soapVersion`. |

Macro parameter names use the `_PROP_` / `_WIRE_` / `_CLS_` convention internally — naming a parameter after a selector keyword like `wireName` would cause the preprocessor to substitute it inside `wireName:` and mangle the resulting selector.

### Adding headers (ObjC)

```objc
WSSEUsernameToken *token = [[WSSEUsernameToken alloc] initWithUsername:@"admin"
                                                                password:@"secret"];
SOAPFixedHeaderProvider *provider = [[SOAPFixedHeaderProvider alloc] initWithHeaders:@[token]];

TemperatureConversionsService *service =
    [[TemperatureConversionsService alloc] initWithSession:nil
                                              authProvider:nil
                                            headerProvider:provider];
```

Custom typed headers — any `SOAPModel` subclass adopts `SOAPHeader` by category conformance (default impl forwards to `encodeSOAPBody:`):

```objc
@interface SessionHeader (SOAPHeaderAdoption) <SOAPHeader> @end
@implementation SessionHeader (SOAPHeaderAdoption) @end
```

The emitter writes that line automatically when the WSDL declares an `<soap:header>`.

### Error handling (ObjC)

```objc
[service operationWithParameters:request
                       completion:^(id response, NSError *error) {
    if ([error.domain isEqualToString:SOAPErrorDomain] && error.code == SOAPErrorCodeFault) {
        SOAPFault *fault = error.userInfo[SOAPFaultKey];
        NSLog(@"%@: %@", fault.code, fault.reason);
    } else if (error) {
        NSLog(@"transport: %@", error);
    } else {
        // use response
    }
}];
```

### Tests + demos

```bash
cd ObjC/SOAPObjCRuntime
swift test                                    # 28 tests
swift run TemperatureConversionsObjCDemo      # live: 100°C = 212°F
swift run CountryInfoObjCDemo                 # live: 6 continents
swift run VIESObjCDemo                        # live: VAT + xs:date
```

---

## Round-trip from the repo root

```bash
make                  # build the wsdl2objc CLI
make swift            # regenerate all 5 Swift fixtures + recompile SOAPMacros
make objc-modern      # regenerate all 5 ObjC fixtures + recompile SOAPObjCRuntime
make clean
```

### Five included fixtures

| WSDL | Lives in | Exercises | Demo |
| --- | --- | --- | --- |
| `TemperatureConversions.wsdl` | `Swift/Samples/TemperatureConversions/` | primitives + `xs:decimal`, single-element request/response | live |
| `CountryInfoService.wsdl` | `Swift/Samples/CountryInfo/` | arrays (`maxOccurs="unbounded"`), nested complex types | live |
| `SessionEcho.wsdl` | `Swift/Samples/SessionEcho/` | typed `<soap:header>` | compile-only (synthetic endpoint) |
| `PurchaseOrder.wsdl` | `Swift/Samples/PurchaseOrder/` | multi-part input messages, one-way operations | compile-only |
| `checkVatService.wsdl` (EU VIES) | `Swift/Samples/VIES/` | `xs:date` + timezone, `xs:boolean`, optional nillable elements, `xsd:restriction` enums | live |

---

## Wire format support

### Supported

- Document/literal SOAP 1.1 + SOAP 1.2 (auto-picked from WSDL binding).
- `xs:string`, `xs:int`/`long`/`short`/`byte` + unsigned variants, `xs:float`, `xs:double`, `xs:decimal`, `xs:boolean`, `xs:base64Binary`.
- `xs:date` and `xs:dateTime` in 9 wire formats (with/without timezone, with/without milliseconds, with/without time component).
- Arrays via `maxOccurs > 1` / `"unbounded"`.
- Multi-part input messages (`<message><part>...</part><part>...</part></message>`).
- One-way operations (no `<output>`).
- Input SOAP headers (typed parameter on the generated operation).
- WS-Security UsernameToken (plain-text password) as a built-in header.
- SOAP faults — surfaced as `SOAPFault` (Swift `throws`) / `NSError` with `SOAPErrorDomain` + `SOAPFaultKey` (ObjC).
- Cross-schema `#import` resolution in the ObjC emitter; per-schema `<prefix>.swift` files in the Swift emitter (fallback `ns1`, `ns2` … when the WSDL uses default namespaces).

### Not supported

- **SOAP RPC/encoded** (`style="rpc" use="encoded"` with `xsi:type` + `SOAP-ENC:Array`). NDFD-style services need a different envelope path.
- **Response-side SOAP headers** — `<output>` headers are silently dropped.
- **WS-Policy** / WS-Addressing structured headers (use the header provider for these).
- **xs:choice**, mixed content, attribute groups — Codable + XMLCoder handles some of this on the Swift side but no fixture exercises it.
- **WSDL parser bug**: `minOccurs`/`maxOccurs` default to `0` instead of the XSD spec's `1` when absent. Emitters normalize `0 → 1`; explicit `minOccurs="0"` (optional) is conflated with absent.

---

## Build prerequisites

- macOS with current Xcode (Swift 6.x toolchain).
- The CLI parser is ObjC under MRR — no ARC; the Makefile sets `-fno-objc-arc`.
- The Swift package depends on:
  - [swift-syntax](https://github.com/swiftlang/swift-syntax) 601+
  - [XMLCoder](https://github.com/CoreOffice/XMLCoder) 0.17.1+
- The ObjC package depends only on Foundation.

---

## License

See `license.txt` — MIT-style, unchanged from the original wsdl2objc.
