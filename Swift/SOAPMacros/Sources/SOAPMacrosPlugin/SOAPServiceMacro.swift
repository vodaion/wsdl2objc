import SwiftSyntax
import SwiftSyntaxMacros

public enum SOAPServiceMacro {}

extension SOAPServiceMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let args = node.arguments?.as(LabeledExprListSyntax.self)
        let endpointExpr = MacroArg.expression(in: args, label: "endpoint") ?? "\"\""
        let versionExpr = MacroArg.expression(in: args, label: "soapVersion") ?? ".v1_1"

        let client: DeclSyntax = "public let client: SOAPClient"

        let initDecl: DeclSyntax = """
            public init(
                session: URLSession = .shared,
                authProvider: SOAPAuthProvider? = nil,
                headerProvider: SOAPHeaderProvider? = nil
            ) {
                self.client = SOAPClient(
                    endpoint: SOAPEndpoint(
                        url: URL(string: \(raw: endpointExpr))!,
                        soapVersion: \(raw: versionExpr)
                    ),
                    session: session,
                    authProvider: authProvider,
                    headerProvider: headerProvider
                )
            }
            """

        return [client, initDecl]
    }
}

extension SOAPServiceMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // An `actor` is already Sendable by default; only emit the conformance
        // when the host is a non-actor type that needs it. Keep it conservative:
        // always emit, the compiler will fold the redundancy away for actors.
        let ext: DeclSyntax = "extension \(type.trimmed): Sendable {}"
        return [ext.cast(ExtensionDeclSyntax.self)]
    }
}
