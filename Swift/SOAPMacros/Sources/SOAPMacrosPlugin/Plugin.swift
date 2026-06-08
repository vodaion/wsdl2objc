import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SOAPMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SOAPServiceMacro.self,
        SOAPOperationMacro.self,
        SOAPTypeMacro.self,
        SOAPElementMacro.self,
        SOAPAttributeMacro.self,
    ]
}
