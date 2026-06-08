import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

/// Minimal in-memory XML tree used for SOAP envelope/body/fault navigation.
/// The actual payload decoding is delegated to `XMLDecoder`; this type only
/// exists so we can find the right element inside `<soap:Body>` and re-emit
/// it as a fragment.
public struct SOAPXMLNode: Sendable {
    public let localName: String
    public let namespace: String?
    public let attributes: [String: String]
    public let children: [SOAPXMLNode]
    public let stringValue: String?

    public init(
        localName: String,
        namespace: String? = nil,
        attributes: [String: String] = [:],
        children: [SOAPXMLNode] = [],
        stringValue: String? = nil
    ) {
        self.localName = localName
        self.namespace = namespace
        self.attributes = attributes
        self.children = children
        self.stringValue = stringValue
    }

    public func firstChild(named name: String) -> SOAPXMLNode? {
        children.first { $0.localName == name || $0.localName.hasSuffix(":\(name)") }
    }
}

extension SOAPXMLNode {
    public static func parseBody(data: Data) throws -> SOAPXMLNode {
        let root = try parse(data: data)
        guard let body = root.firstChild(named: "Body") ?? root.descendant(localName: "Body") else {
            throw SOAPTransportError.decoding("envelope has no <Body>")
        }
        return body
    }

    public static func parse(data: Data) throws -> SOAPXMLNode {
        let parser = XMLParser(data: data)
        let delegate = TreeBuilder()
        parser.delegate = delegate
        parser.shouldProcessNamespaces = true
        parser.shouldReportNamespacePrefixes = false
        guard parser.parse(), let root = delegate.root else {
            throw SOAPTransportError.decoding(parser.parserError?.localizedDescription ?? "XML parse failed")
        }
        return root
    }

    fileprivate func descendant(localName: String) -> SOAPXMLNode? {
        if self.localName == localName { return self }
        for c in children {
            if let hit = c.descendant(localName: localName) { return hit }
        }
        return nil
    }

    /// Re-emits the subtree rooted at this node as a standalone XML string.
    /// Used by `_decodeSOAPResponse` to hand a clean fragment to XMLDecoder.
    public func serialize() -> String {
        var attrs = ""
        // Sorted for deterministic output — helps reproducibility but also
        // golden-file tests if anyone adds them later.
        for (k, v) in attributes.sorted(by: { $0.key < $1.key }) {
            attrs += " \(k)=\"\(SOAPXMLEscape.escape(v))\""
        }
        if children.isEmpty {
            let text = stringValue.map(SOAPXMLEscape.escape) ?? ""
            if text.isEmpty {
                return "<\(localName)\(attrs)/>"
            }
            return "<\(localName)\(attrs)>\(text)</\(localName)>"
        }
        var inner = stringValue.map(SOAPXMLEscape.escape) ?? ""
        for c in children { inner += c.serialize() }
        return "<\(localName)\(attrs)>\(inner)</\(localName)>"
    }
}

private final class TreeBuilder: NSObject, XMLParserDelegate {
    private struct Frame {
        var localName: String
        var namespace: String?
        var attributes: [String: String]
        var children: [SOAPXMLNode]
        var text: String
    }

    fileprivate var root: SOAPXMLNode?
    private var stack: [Frame] = []

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String]) {
        stack.append(Frame(localName: elementName, namespace: namespaceURI, attributes: attributeDict, children: [], text: ""))
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard !stack.isEmpty else { return }
        stack[stack.count - 1].text += string
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        guard let frame = stack.popLast() else { return }
        let trimmed = frame.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let node = SOAPXMLNode(
            localName: frame.localName,
            namespace: frame.namespace,
            attributes: frame.attributes,
            children: frame.children,
            stringValue: trimmed.isEmpty ? nil : trimmed
        )
        if stack.isEmpty {
            root = node
        } else {
            stack[stack.count - 1].children.append(node)
        }
    }
}

enum SOAPFaultParser {
    static func parse(data: Data, httpStatus: Int) throws -> SOAPFault? {
        let root = try SOAPXMLNode.parse(data: data)
        guard let body = root.firstChild(named: "Body") ?? root.descendant(localName: "Body"),
              let faultNode = body.firstChild(named: "Fault") else {
            if httpStatus >= 400 {
                return SOAPFault(code: "HTTP", reason: "HTTP \(httpStatus)", detail: nil, httpStatus: httpStatus)
            }
            return nil
        }
        let code = faultNode.firstChild(named: "faultcode")?.stringValue
            ?? faultNode.firstChild(named: "Code")?.firstChild(named: "Value")?.stringValue
            ?? "Unknown"
        let reason = faultNode.firstChild(named: "faultstring")?.stringValue
            ?? faultNode.firstChild(named: "Reason")?.firstChild(named: "Text")?.stringValue
            ?? ""
        let detail = faultNode.firstChild(named: "detail")?.stringValue
            ?? faultNode.firstChild(named: "Detail")?.stringValue
        return SOAPFault(code: code, reason: reason, detail: detail, httpStatus: httpStatus)
    }
}
