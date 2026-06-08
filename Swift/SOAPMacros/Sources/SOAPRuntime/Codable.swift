import Foundation
import XMLCoder

/// Adopted by every macro-generated `@SOAPType` struct. The macro provides
/// the static metadata (`_soapName` / `_soapNamespace`) and a `CodingKeys`
/// enum mapping property names to wire element names. Default impls in this
/// file route through `XMLEncoder` / `XMLDecoder` for the actual wire work.
public protocol SOAPCodable: Codable, Sendable {
    static var _soapNamespace: String { get }
    static var _soapName: String { get }
}

// MARK: - Encoder/decoder factories

extension SOAPCodable {
    /// Configured `XMLEncoder` shared by every `_encodeSOAPBody()` call.
    /// Callers can swap individual properties on the returned instance, but
    /// it's a fresh instance every call — XMLEncoder isn't documented as
    /// thread-safe.
    public static func _soapXMLEncoder() -> XMLEncoder {
        let e = XMLEncoder()
        e.outputFormatting = []
        e.dateEncodingStrategy = .formatted(SOAPDateFormat.xsDateTimeISO8601)
        e.dataEncodingStrategy = .base64
        return e
    }

    public static func _soapXMLDecoder() -> XMLDecoder {
        let d = XMLDecoder()
        d.dateDecodingStrategy = .custom(SOAPDateFormat.decode(_:))
        d.dataDecodingStrategy = .base64
        d.shouldProcessNamespaces = true
        return d
    }
}

// MARK: - xs:date / xs:dateTime codec

/// xs:date and xs:dateTime parser. The spec allows both date-only
/// (`2026-06-05+02:00`) and date+time (`2026-06-05T12:00:00Z`) variants,
/// each with optional timezone offset. XMLCoder's bundled `.iso8601` only
/// handles the strict ISO 8601 datetime form, so we hand-roll a series of
/// `DateFormatter` fallbacks here.
public enum SOAPDateFormat {
    private static let formatters: [DateFormatter] = {
        let patterns = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-ddXXXXX",   // xs:date with tz offset (VIES requestDate)
            "yyyy-MM-dd'Z'",
            "yyyy-MM-dd",
        ]
        return patterns.map { pattern in
            let f = DateFormatter()
            f.locale = Locale(identifier: "en_US_POSIX")
            f.timeZone = TimeZone(secondsFromGMT: 0)
            f.dateFormat = pattern
            return f
        }
    }()

    /// Canonical xs:dateTime form used when encoding requests.
    public static let xsDateTimeISO8601: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return f
    }()

    public static func decode(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        for f in formatters {
            if let d = f.date(from: raw) { return d }
        }
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "value `\(raw)` is not a recognized xs:date or xs:dateTime"
        )
    }
}

// MARK: - Encode (body payload)

extension SOAPCodable {
    /// Encodes the receiver as a standalone XML element fragment using
    /// `Self._soapName` as the root element and `Self._soapNamespace` as the
    /// default-namespace attribute. The result is dropped straight into
    /// `<soap:Body>` by `SOAPClient.send(...)`.
    public func _encodeSOAPBody() throws -> String {
        try _encodeSOAPBody(withRootName: Self._soapName)
    }

    /// Encodes the receiver with a caller-chosen root element name. Used by
    /// the multi-part body path: a WSDL message part can reference an
    /// `<element name="X" type="tns:Y"/>`, in which case the wire element is
    /// `<X>...</X>` even though the underlying complex type is named `Y`.
    public func _encodeSOAPBody(withRootName rootName: String) throws -> String {
        let encoder = Self._soapXMLEncoder()
        let data = try encoder.encode(self, withRootKey: rootName)
        guard var xml = String(data: data, encoding: .utf8) else {
            throw SOAPTransportError.decoding("encoded body was not UTF-8")
        }
        let opener = "<\(rootName)"
        if let openRange = xml.range(of: opener) {
            let insertion = " xmlns=\"\(Self._soapNamespace)\""
            xml.insert(contentsOf: insertion, at: openRange.upperBound)
        }
        return xml
    }
}

// MARK: - Body parts (multi-part WSDL message support)

/// One of the elements inside `<soap:Body>`. WSDL operations can have an
/// input message with multiple `<part>` children — each part becomes one
/// SOAP body element. Both `SOAPCodable` complex types and XSD primitives
/// (mapped to Swift `String`/`Int`/`Double`/…) need a uniform way to render.
public protocol SOAPBodyPart: Sendable {
    func _encodeSOAPBodyPart(named name: String, namespace: String?) throws -> String
}

extension SOAPCodable {
    public func _encodeSOAPBodyPart(named name: String, namespace: String?) throws -> String {
        // Use the caller-provided wire name; ignore the namespace hint because
        // SOAPCodable already carries its own _soapNamespace.
        try _encodeSOAPBody(withRootName: name)
    }
}

/// Primitive that knows how to render as `<name>value</name>`.
public protocol _SOAPBodyPartPrimitive: SOAPBodyPart {
    var _soapBodyPartStringValue: String { get }
}

extension _SOAPBodyPartPrimitive {
    public func _encodeSOAPBodyPart(named name: String, namespace: String?) throws -> String {
        let nsAttr = namespace.flatMap { $0.isEmpty ? nil : $0 }.map { " xmlns=\"\($0)\"" } ?? ""
        return "<\(name)\(nsAttr)>\(SOAPXMLEscape.escape(_soapBodyPartStringValue))</\(name)>"
    }
}

extension String: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { self }
}

extension Int: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { String(self) }
}

extension Int64: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { String(self) }
}

extension UInt: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { String(self) }
}

extension Double: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { String(self) }
}

extension Float: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { String(self) }
}

extension Bool: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { self ? "true" : "false" }
}

extension Decimal: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String { "\(self)" }
}

extension Date: _SOAPBodyPartPrimitive {
    public var _soapBodyPartStringValue: String {
        ISO8601DateFormatter().string(from: self)
    }
}

// MARK: - Decode (response wrapped in soap:Envelope/soap:Body)

extension SOAPCodable {
    /// Parses the envelope, locates the response element inside `<soap:Body>`,
    /// re-serializes that subtree as standalone XML, then decodes via
    /// `XMLDecoder`. The two-step extract-then-decode keeps namespace prefix
    /// handling on `SOAPXMLNode` (which uses `XMLParser` with namespace
    /// processing) and lets `XMLDecoder` work against a clean root fragment.
    public static func _decodeSOAPResponse(_ data: Data, operationName: String) throws -> Self {
        let body = try SOAPXMLNode.parseBody(data: data)
        // Prefer the response type's own name; fall back to the operation's
        // name (some servers wrap inconsistently) and finally the body itself
        // if it's already a single-child container.
        let root = body.firstChild(named: Self._soapName)
            ?? body.firstChild(named: operationName)
            ?? body.children.first
            ?? body
        let elementXML = root.serialize()
        guard let elementData = elementXML.data(using: .utf8) else {
            throw SOAPTransportError.decoding("response element not UTF-8")
        }
        let decoder = Self._soapXMLDecoder()
        return try decoder.decode(Self.self, from: elementData)
    }
}

// MARK: - Small XML helpers retained for header serialization

enum SOAPXMLEscape {
    /// Escapes the XML-significant character set. Used by built-in headers
    /// (e.g. `WSSEUsernameToken`) that build their wire string by hand.
    static func escape(_ s: String) -> String {
        var result = ""
        result.reserveCapacity(s.count)
        for ch in s {
            switch ch {
            case "&": result += "&amp;"
            case "<": result += "&lt;"
            case ">": result += "&gt;"
            case "\"": result += "&quot;"
            case "'": result += "&apos;"
            default: result.append(ch)
            }
        }
        return result
    }
}
