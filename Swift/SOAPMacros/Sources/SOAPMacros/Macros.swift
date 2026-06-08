@_exported import SOAPRuntime
@_exported import XMLCoder

/// Attach to a `struct` or `actor` declaration that represents a SOAP service.
/// The macro injects a `client: SOAPClient` stored property and a designated
/// initializer that wires up the endpoint, plus a `Sendable` conformance.
///
/// Example:
///
///     @SOAPService(endpoint: "https://example.com/Friends", soapVersion: .v1_1)
///     public actor FriendsService { /* operations go here */ }
@attached(member, names: named(client), named(init))
@attached(extension, conformances: Sendable)
public macro SOAPService(
    endpoint: String,
    soapVersion: SOAPVersion = .v1_1
) = #externalMacro(module: "SOAPMacrosPlugin", type: "SOAPServiceMacro")

/// Attach to a `func` declaration inside an `@SOAPService` type. The first
/// parameter is the SOAP body (`input: SomeRequest`); any parameter whose
/// name appears in `headerParams` is treated as a typed SOAP header and gets
/// folded into the `<soap:Header>` block. The function must `async throws ->`
/// a response type. The macro provides the body — building the envelope,
/// dispatching via the enclosing `client`, and decoding the response.
///
/// Example:
///
///     @SOAPOperation(name: "DoStuff", soapAction: "urn:DoStuff",
///                    headerParams: ["session"])
///     public func doStuff(input: DoStuffRequest, session: SessionHeader)
///         async throws -> DoStuffResponse
@attached(body)
public macro SOAPOperation(
    name: String,
    soapAction: String = "",
    headerParams: [String] = [],
    bodyWireNames: [String] = [],
    bodyNamespace: String = ""
) = #externalMacro(module: "SOAPMacrosPlugin", type: "SOAPOperationMacro")

/// Attach to a `struct` declaration that represents a complex type in a SOAP
/// schema. The macro adds `_soapNamespace` / `_soapName` constants plus a
/// `CodingKeys` enum that maps each `@SOAPElement`/`@SOAPAttribute` property
/// to its wire name, then conforms the type to `SOAPCodable` (`Codable +
/// Sendable`). When the struct has `@SOAPAttribute` properties the macro
/// also conforms it to `DynamicNodeEncoding` / `DynamicNodeDecoding` so
/// XMLCoder serializes them as attributes rather than child elements.
@attached(
    member,
    names: named(_soapNamespace), named(_soapName), named(CodingKeys)
)
@attached(
    extension,
    conformances: SOAPCodable, DynamicNodeEncoding, DynamicNodeDecoding,
    names: named(nodeEncoding(for:)), named(nodeDecoding(for:))
)
public macro SOAPType(
    namespace: String,
    name: String
) = #externalMacro(module: "SOAPMacrosPlugin", type: "SOAPTypeMacro")

/// Marker attached to a stored property inside an `@SOAPType` struct to map
/// the property to an XML child element. Read at expansion time by `@SOAPType`.
@attached(peer)
public macro SOAPElement(
    name: String = "",
    namespace: String = "",
    minOccurs: Int = 1,
    maxOccurs: Int = 1,
    nillable: Bool = false
) = #externalMacro(module: "SOAPMacrosPlugin", type: "SOAPElementMacro")

/// Marker attached to a stored property inside an `@SOAPType` struct to map
/// the property to an XML attribute. Read at expansion time by `@SOAPType`.
@attached(peer)
public macro SOAPAttribute(
    name: String = "",
    namespace: String = ""
) = #externalMacro(module: "SOAPMacrosPlugin", type: "SOAPAttributeMacro")
