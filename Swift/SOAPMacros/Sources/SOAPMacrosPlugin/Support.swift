import Foundation
import SwiftSyntax

enum MacroArg {
    static func string(in args: LabeledExprListSyntax?, label: String) -> String? {
        guard let args else { return nil }
        for arg in args where arg.label?.text == label {
            return arg.expression.description
        }
        return nil
    }

    static func unquotedString(in args: LabeledExprListSyntax?, label: String) -> String? {
        guard let raw = string(in: args, label: label) else { return nil }
        return raw.trimmingCharacters(in: .init(charactersIn: "\""))
    }

    static func expression(in args: LabeledExprListSyntax?, label: String) -> String? {
        guard let args else { return nil }
        for arg in args where arg.label?.text == label {
            return arg.expression.description
        }
        return nil
    }

    /// Parses a literal array of string literals, e.g. `["a", "b"]`, returning
    /// the unquoted contents `["a", "b"]`. Returns `[]` when the argument is
    /// missing or isn't a recognizable string-array literal.
    static func stringArrayLiteral(in args: LabeledExprListSyntax?, label: String) -> [String] {
        guard let args else { return [] }
        for arg in args where arg.label?.text == label {
            guard let array = arg.expression.as(ArrayExprSyntax.self) else { return [] }
            var out: [String] = []
            for element in array.elements {
                if let str = element.expression.as(StringLiteralExprSyntax.self) {
                    out.append(str.segments.description)
                }
            }
            return out
        }
        return []
    }
}

struct SOAPProperty {
    let name: String
    /// Inner element type with Optional and Array wrappers stripped.
    let type: String
    let isOptional: Bool
    let isArray: Bool
    let kind: Kind
    let soapName: String

    enum Kind { case element, attribute }
}

enum PropertyScanner {
    static func scan(_ decl: some DeclGroupSyntax) -> [SOAPProperty] {
        var out: [SOAPProperty] = []
        for member in decl.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }
            guard let binding = varDecl.bindings.first,
                  let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
                  let typeAnno = binding.typeAnnotation?.type else { continue }

            let name = pattern.identifier.text
            var typeStr = typeAnno.trimmedDescription

            // Outer wrappers: Optional first (`[T]?` → optional array), then Array.
            var isOptional = false
            if typeStr.hasSuffix("?") {
                isOptional = true
                typeStr = String(typeStr.dropLast())
            }
            var isArray = false
            if typeStr.hasPrefix("[") && typeStr.hasSuffix("]") {
                isArray = true
                typeStr = String(typeStr.dropFirst().dropLast())
            }

            var kind: SOAPProperty.Kind? = nil
            var soapName = name
            for attr in varDecl.attributes {
                guard let attr = attr.as(AttributeSyntax.self) else { continue }
                let attrName = attr.attributeName.trimmedDescription
                switch attrName {
                case "SOAPElement":
                    kind = .element
                case "SOAPAttribute":
                    kind = .attribute
                default:
                    continue
                }
                if let args = attr.arguments?.as(LabeledExprListSyntax.self),
                   let explicit = MacroArg.unquotedString(in: args, label: "name"),
                   !explicit.isEmpty {
                    soapName = explicit
                }
            }
            guard let kind else { continue }
            out.append(SOAPProperty(name: name, type: typeStr, isOptional: isOptional, isArray: isArray, kind: kind, soapName: soapName))
        }
        return out
    }
}
