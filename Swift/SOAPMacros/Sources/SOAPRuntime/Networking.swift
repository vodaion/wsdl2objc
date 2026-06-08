import Foundation

public enum SOAPVersion: Sendable, Equatable {
    case v1_1
    case v1_2

    public var contentType: String {
        switch self {
        case .v1_1: return "text/xml; charset=utf-8"
        case .v1_2: return "application/soap+xml; charset=utf-8"
        }
    }

    public var envelopeNamespace: String {
        switch self {
        case .v1_1: return "http://schemas.xmlsoap.org/soap/envelope/"
        case .v1_2: return "http://www.w3.org/2003/05/soap-envelope"
        }
    }
}

public struct SOAPEndpoint: Sendable {
    public let url: URL
    public let soapVersion: SOAPVersion

    public init(url: URL, soapVersion: SOAPVersion = .v1_1) {
        self.url = url
        self.soapVersion = soapVersion
    }
}

public protocol SOAPAuthProvider: Sendable {
    func authenticate(_ request: inout URLRequest) async throws
}

public struct SOAPFault: Error, Sendable, Equatable {
    public let code: String
    public let reason: String
    public let detail: String?
    public let httpStatus: Int?

    public init(code: String, reason: String, detail: String? = nil, httpStatus: Int? = nil) {
        self.code = code
        self.reason = reason
        self.detail = detail
        self.httpStatus = httpStatus
    }
}

public enum SOAPTransportError: Error, Sendable, Equatable {
    case nonHTTPResponse
    case invalidResponseMIMEType(String?)
    case decoding(String)
    case emptyBody
}

/// A single SOAP header block (a child of `<soap:Header>`). Implementations
/// return the full XML element string including the wrapping element tag —
/// `WSSEUsernameToken` is the built-in example.
///
/// Existing `SOAPEncodable` types can opt in as headers by declaring
/// conformance: the default implementation forwards to `_encodeSOAPBody()`.
public protocol SOAPHeader: Sendable {
    func _encodeSOAPHeader() throws -> String
}

extension SOAPHeader where Self: SOAPCodable {
    public func _encodeSOAPHeader() throws -> String {
        try _encodeSOAPBody()
    }
}

/// Supplies the per-call header list. Built-in: `FixedHeaderProvider`.
public protocol SOAPHeaderProvider: Sendable {
    func headers(forSoapAction action: String) async throws -> [any SOAPHeader]
}

public struct FixedHeaderProvider: SOAPHeaderProvider {
    public let headers: [any SOAPHeader]
    public init(_ headers: [any SOAPHeader]) { self.headers = headers }
    public func headers(forSoapAction action: String) async throws -> [any SOAPHeader] {
        headers
    }
}

/// WS-Security UsernameToken — the most common SOAP-level auth header.
/// Plain-text password only; digest+nonce can be added if needed.
public struct WSSEUsernameToken: SOAPHeader {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    private static let wsseNS = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
    private static let passwordTextType = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"

    public func _encodeSOAPHeader() throws -> String {
        let u = SOAPXMLEscape.escape(username)
        let p = SOAPXMLEscape.escape(password)
        return "<wsse:Security xmlns:wsse=\"\(Self.wsseNS)\">"
            + "<wsse:UsernameToken>"
            + "<wsse:Username>\(u)</wsse:Username>"
            + "<wsse:Password Type=\"\(Self.passwordTextType)\">\(p)</wsse:Password>"
            + "</wsse:UsernameToken>"
            + "</wsse:Security>"
    }
}

public enum SOAPEnvelope {
    public static func wrap(body: String, version: SOAPVersion) -> String {
        // Convenience overload kept for callers that never use headers.
        (try? wrap(body: body, headers: [], version: version)) ?? ""
    }

    public static func wrap(body: String, headers: [any SOAPHeader], version: SOAPVersion) throws -> String {
        let envNS = version.envelopeNamespace
        if headers.isEmpty {
            return """
            <?xml version="1.0" encoding="UTF-8"?>
            <soap:Envelope xmlns:soap="\(envNS)"><soap:Body>\(body)</soap:Body></soap:Envelope>
            """
        }
        let headerXML = try headers.map { try $0._encodeSOAPHeader() }.joined()
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <soap:Envelope xmlns:soap="\(envNS)"><soap:Header>\(headerXML)</soap:Header><soap:Body>\(body)</soap:Body></soap:Envelope>
        """
    }
}

public actor SOAPClient {
    public let endpoint: SOAPEndpoint
    public let session: URLSession
    public let authProvider: SOAPAuthProvider?
    public let headerProvider: SOAPHeaderProvider?
    public var logTraffic: Bool = false

    public init(
        endpoint: SOAPEndpoint,
        session: URLSession = .shared,
        authProvider: SOAPAuthProvider? = nil,
        headerProvider: SOAPHeaderProvider? = nil
    ) {
        self.endpoint = endpoint
        self.session = session
        self.authProvider = authProvider
        self.headerProvider = headerProvider
    }

    public func setLogging(_ enabled: Bool) {
        self.logTraffic = enabled
    }

    public func send(
        soapAction: String,
        body: String,
        headers: [any SOAPHeader] = [],
        timeout: TimeInterval = 60
    ) async throws -> Data {
        var request = URLRequest(url: endpoint.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout)
        request.httpMethod = "POST"
        request.setValue(endpoint.soapVersion.contentType, forHTTPHeaderField: "Content-Type")
        if !soapAction.isEmpty {
            request.setValue("\"\(soapAction)\"", forHTTPHeaderField: "SOAPAction")
        }
        request.setValue("wsdl2swift", forHTTPHeaderField: "User-Agent")

        // Provider-supplied headers come first, then per-call headers — this
        // lets a global WSSE token appear before operation-specific addressing.
        var allHeaders: [any SOAPHeader] = []
        if let providerHeaders = try await headerProvider?.headers(forSoapAction: soapAction) {
            allHeaders.append(contentsOf: providerHeaders)
        }
        allHeaders.append(contentsOf: headers)
        let envelope = try SOAPEnvelope.wrap(body: body, headers: allHeaders, version: endpoint.soapVersion)
        request.httpBody = envelope.data(using: .utf8)

        try await authProvider?.authenticate(&request)

        if logTraffic { print("--> POST \(endpoint.url.absoluteString)\n\(envelope)") }

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw SOAPTransportError.nonHTTPResponse }

        if logTraffic, let text = String(data: data, encoding: .utf8) {
            print("<-- \(http.statusCode) \(http.mimeType ?? "?")\n\(text)")
        }

        let mime = http.value(forHTTPHeaderField: "Content-Type") ?? ""
        guard mime.contains("xml") else { throw SOAPTransportError.invalidResponseMIMEType(mime) }
        guard !data.isEmpty else { throw SOAPTransportError.emptyBody }

        if let fault = try SOAPFaultParser.parse(data: data, httpStatus: http.statusCode) {
            throw fault
        }
        return data
    }
}
