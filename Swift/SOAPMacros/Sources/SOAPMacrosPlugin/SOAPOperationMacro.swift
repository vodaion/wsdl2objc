import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

public enum SOAPOperationMacro: BodyMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            context.diagnose(.init(node: Syntax(node), message: SOAPMacroMessage.notAFunction))
            return []
        }
        let args = node.arguments?.as(LabeledExprListSyntax.self)
        let nameExpr = MacroArg.expression(in: args, label: "name") ?? "\"\""
        let actionExpr = MacroArg.expression(in: args, label: "soapAction") ?? "\"\""
        let headerParamNames = MacroArg.stringArrayLiteral(in: args, label: "headerParams")
        let bodyWireNames = MacroArg.stringArrayLiteral(in: args, label: "bodyWireNames")
        let bodyNamespace = MacroArg.unquotedString(in: args, label: "bodyNamespace") ?? ""

        // Partition function parameters into body parts and header parts in
        // declaration order. The emitter generates signatures shaped like:
        //   func op(p1: T1, p2: T2, sessionHeader: H)
        // where `sessionHeader` would appear in `headerParams`.
        var bodyParamNames: [String] = []
        for param in funcDecl.signature.parameterClause.parameters {
            let label = param.firstName.text
            if !headerParamNames.contains(label) {
                bodyParamNames.append(label)
            }
        }

        // Build the body payload by encoding each body part. For SOAPCodable
        // parts the macro can't tell the type at expansion time, so we always
        // call `_encodeSOAPBodyPart(named:namespace:)` — the protocol picks the
        // right overload (SOAPCodable ignores `namespace`, primitives use it).
        var stmts: [CodeBlockItemSyntax] = []
        if bodyParamNames.isEmpty {
            stmts.append("let _payload = \"\"")
        } else {
            let nsArg = bodyNamespace.isEmpty ? "nil" : "\"\(bodyNamespace)\""
            var fragmentRefs: [String] = []
            for (i, paramName) in bodyParamNames.enumerated() {
                let wire: String
                if i < bodyWireNames.count {
                    wire = "\"\(bodyWireNames[i])\""
                } else {
                    // Single-body backward-compat: SOAPCodable types fall back to
                    // their own `_soapName`, primitives can't (compile error at use
                    // site, which is the right outcome).
                    wire = "type(of: \(paramName))._soapName"
                }
                let line = "let _p\(i) = try \(paramName)._encodeSOAPBodyPart(named: \(wire), namespace: \(nsArg))"
                stmts.append("\(raw: line)")
                fragmentRefs.append("_p\(i)")
            }
            let joined = fragmentRefs.joined(separator: " + ")
            stmts.append("let _payload = \(raw: joined)")
        }

        // Header collection (existing behavior — names from `headerParams:`).
        if headerParamNames.isEmpty {
            stmts.append("let _data = try await self.client.send(soapAction: \(raw: actionExpr), body: _payload)")
        } else {
            let arr = "[" + headerParamNames.joined(separator: ", ") + "]"
            stmts.append("let _headers: [any SOAPHeader] = \(raw: arr)")
            stmts.append("let _data = try await self.client.send(soapAction: \(raw: actionExpr), body: _payload, headers: _headers)")
        }

        // Return decoding. If the function has no return clause or returns
        // Void, just dispatch and discard the response.
        if let returnType = funcDecl.signature.returnClause?.type.trimmedDescription,
           returnType != "Void", returnType != "()" {
            stmts.append("return try \(raw: returnType)._decodeSOAPResponse(_data, operationName: \(raw: nameExpr))")
        } else {
            stmts.append("_ = _data")
        }
        return stmts
    }
}

enum SOAPMacroMessage: String, DiagnosticMessage {
    case notAFunction
    case missingInput
    case missingReturnType

    var severity: DiagnosticSeverity { .error }
    var diagnosticID: MessageID { MessageID(domain: "SOAPMacros", id: rawValue) }
    var message: String {
        switch self {
        case .notAFunction: return "@SOAPOperation can only be applied to function declarations"
        case .missingInput: return "@SOAPOperation requires at least one input parameter"
        case .missingReturnType: return "@SOAPOperation requires an explicit return type"
        }
    }
}
