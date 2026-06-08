import SwiftSyntax
import SwiftSyntaxMacros

public enum SOAPTypeMacro {}

extension SOAPTypeMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let args = node.arguments?.as(LabeledExprListSyntax.self)
        let nsExpr = MacroArg.expression(in: args, label: "namespace") ?? "\"\""
        let nameExpr = MacroArg.expression(in: args, label: "name") ?? "\"\""

        var members: [DeclSyntax] = [
            "public static let _soapNamespace: String = \(raw: nsExpr)",
            "public static let _soapName: String = \(raw: nameExpr)",
        ]

        // CodingKeys: one case per property mapping Swift name → wire name.
        // Codable synthesis picks this up; XMLCoder consumes the rawValue as
        // the element/attribute name on the wire.
        let props = PropertyScanner.scan(declaration)
        if !props.isEmpty {
            let cases = props.map { p in
                "        case \(p.name) = \"\(p.soapName)\""
            }.joined(separator: "\n")
            let codingKeys: DeclSyntax = """
                enum CodingKeys: String, CodingKey {
                \(raw: cases)
                }
                """
            members.append(codingKeys)
        }

        return members
    }
}

extension SOAPTypeMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let props = PropertyScanner.scan(declaration)
        let hasAttributes = props.contains { $0.kind == .attribute }

        // Bare SOAPCodable conformance — Codable + Sendable synthesis happens
        // automatically off the macro-injected CodingKeys.
        let codableExt: DeclSyntax = "extension \(type.trimmed): SOAPCodable {}"
        var result: [ExtensionDeclSyntax] = [codableExt.cast(ExtensionDeclSyntax.self)]

        // DynamicNodeEncoding/Decoding only when the schema mixes XML
        // attributes and elements — XMLCoder defaults to element-encoding so
        // a type with only elements needs no extra conformance.
        guard hasAttributes else { return result }

        let switchCases = props.map { p -> String in
            let value = p.kind == .attribute ? ".attribute" : ".element"
            return "            case \"\(p.soapName)\": return \(value)"
        }.joined(separator: "\n")

        let encDecl: DeclSyntax = """
            extension \(type.trimmed): DynamicNodeEncoding {
                public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
                    switch key.stringValue {
            \(raw: switchCases)
                    default: return .element
                    }
                }
            }
            """
        let decDecl: DeclSyntax = """
            extension \(type.trimmed): DynamicNodeDecoding {
                public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
                    switch key.stringValue {
            \(raw: switchCases)
                    default: return .element
                    }
                }
            }
            """
        result.append(encDecl.cast(ExtensionDeclSyntax.self))
        result.append(decDecl.cast(ExtensionDeclSyntax.self))
        return result
    }
}
