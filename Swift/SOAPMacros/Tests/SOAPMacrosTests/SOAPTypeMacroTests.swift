import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
@testable import SOAPMacrosPlugin

private let testMacros: [String: Macro.Type] = [
    "SOAPType": SOAPTypeMacro.self,
    "SOAPElement": SOAPElementMacro.self,
    "SOAPAttribute": SOAPAttributeMacro.self,
    "SOAPService": SOAPServiceMacro.self,
    "SOAPOperation": SOAPOperationMacro.self,
]

final class SOAPTypeMacroTests: XCTestCase {
    func testSimpleType() {
        assertMacroExpansion(
            """
            @SOAPType(namespace: "urn:Friends", name: "req")
            public struct R {
                @SOAPElement(name: "friend") public var friend: String
            }
            """,
            expandedSource: """
            public struct R {
                public var friend: String

                public static let _soapNamespace: String = "urn:Friends"

                public static let _soapName: String = "req"

                enum CodingKeys: String, CodingKey {
                        case friend = "friend"
                }
            }

            extension R: SOAPCodable {
            }
            """,
            macros: testMacros
        )
    }

    func testTypeWithAttributeGetsDynamicNodeProtocols() {
        assertMacroExpansion(
            """
            @SOAPType(namespace: "urn:demo", name: "Item")
            public struct Item {
                @SOAPAttribute(name: "id") public var id: String
                @SOAPElement(name: "label") public var label: String
            }
            """,
            expandedSource: """
            public struct Item {
                public var id: String
                public var label: String

                public static let _soapNamespace: String = "urn:demo"

                public static let _soapName: String = "Item"

                enum CodingKeys: String, CodingKey {
                        case id = "id"
                        case label = "label"
                }
            }

            extension Item: SOAPCodable {
            }

            extension Item: DynamicNodeEncoding {
                public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
                    switch key.stringValue {
                        case "id":
                        return .attribute
                        case "label":
                        return .element
                    default:
                        return .element
                    }
                }
            }

            extension Item: DynamicNodeDecoding {
                public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
                    switch key.stringValue {
                        case "id":
                        return .attribute
                        case "label":
                        return .element
                    default:
                        return .element
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testServiceExpansionShape() {
        // We don't pin the exact whitespace here — just verify the macro emits
        // a `client` member and an init that constructs a SOAPClient.
        assertMacroExpansion(
            """
            @SOAPService(endpoint: "https://example.com/Friends", soapVersion: .v1_1)
            public actor S {
            }
            """,
            expandedSource: """
            public actor S {

                public let client: SOAPClient

                public init(
                    session: URLSession = .shared,
                    authProvider: SOAPAuthProvider? = nil,
                    headerProvider: SOAPHeaderProvider? = nil
                ) {
                    self.client = SOAPClient(
                        endpoint: SOAPEndpoint(
                            url: URL(string: "https://example.com/Friends")!,
                            soapVersion: .v1_1
                        ),
                        session: session,
                        authProvider: authProvider,
                        headerProvider: headerProvider
                    )
                }
            }

            extension S: Sendable {
            }
            """,
            macros: testMacros
        )
    }
}
