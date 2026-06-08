// Generated from WSDL. Do not edit — regenerate with wsdl2objc.
// namespace: http://www.yoerg.net

import Foundation
import SOAPMacros

@SOAPType(namespace: "http://www.yoerg.net", name: "sendPORequest")
public struct SendPORequest {
    @SOAPElement(name: "customerId")
    public var customerId: Int

    @SOAPElement(name: "purchaseOrderNumber")
    public var purchaseOrderNumber: Int

    @SOAPElement(name: "productId")
    public var productId: Int

    @SOAPElement(name: "quantity")
    public var quantity: Int

    public init(customerId: Int, purchaseOrderNumber: Int, productId: Int, quantity: Int) {
        self.customerId = customerId
        self.purchaseOrderNumber = purchaseOrderNumber
        self.productId = productId
        self.quantity = quantity
    }
}

@SOAPType(namespace: "http://www.yoerg.net", name: "correlationset")
public struct Correlationset {
    @SOAPElement(name: "PurchaseOrder")
    public var purchaseOrder: Correlationsetvalues

    public init(purchaseOrder: Correlationsetvalues) {
        self.purchaseOrder = purchaseOrder
    }
}

@SOAPType(namespace: "http://www.yoerg.net", name: "sendScheduleRequest")
public struct SendScheduleRequest {
    @SOAPElement(name: "shipDate")
    public var shipDate: Date

    @SOAPElement(name: "customerId")
    public var customerId: Int

    @SOAPElement(name: "purchaseOrderNumber")
    public var purchaseOrderNumber: Int

    public init(shipDate: Date, customerId: Int, purchaseOrderNumber: Int) {
        self.shipDate = shipDate
        self.customerId = customerId
        self.purchaseOrderNumber = purchaseOrderNumber
    }
}

@SOAPType(namespace: "http://www.yoerg.net", name: "sendInvoiceRequest")
public struct SendInvoiceRequest {
    @SOAPElement(name: "price")
    public var price: Double

    @SOAPElement(name: "customerId")
    public var customerId: Int

    @SOAPElement(name: "purchaseOrderNumber")
    public var purchaseOrderNumber: Int

    public init(price: Double, customerId: Int, purchaseOrderNumber: Int) {
        self.price = price
        self.customerId = customerId
        self.purchaseOrderNumber = purchaseOrderNumber
    }
}

@SOAPType(namespace: "http://www.yoerg.net", name: "correlationsetvalues")
public struct Correlationsetvalues {
    @SOAPElement(name: "PurchaseOrderNumber")
    public var purchaseOrderNumber: String

    @SOAPElement(name: "customerID")
    public var customerID: String

    public init(purchaseOrderNumber: String, customerID: String) {
        self.purchaseOrderNumber = purchaseOrderNumber
        self.customerID = customerID
    }
}

@SOAPService(endpoint: "http://localhost:8080/axis/services/ListenerService", soapVersion: .v1_1)
public actor ListenerServiceService {
    @SOAPOperation(name: "sendMyPurchaseOrder", soapAction: "", bodyWireNames: ["sendPurchaseOrder", "correlations", "portType", "partnerLink"], bodyNamespace: "http://www.yoerg.net")
    public func sendMyPurchaseOrder(sendPurchaseOrderBody: SendPORequest, correlationsBody: Correlationset, portTypeBody: String, partnerLinkBody: String) async throws

    @SOAPOperation(name: "sendMySchedule", soapAction: "", bodyWireNames: ["sendSchedule", "correlations", "portType", "partnerLink"], bodyNamespace: "http://www.yoerg.net")
    public func sendMySchedule(sendScheduleBody: SendScheduleRequest, correlationBody: Correlationset, portTypeBody: String, partnerLinkBody: String) async throws

    @SOAPOperation(name: "sendInvoice", soapAction: "", bodyWireNames: ["sendInvoice", "correlations", "portType", "partnerLink"], bodyNamespace: "http://www.yoerg.net")
    public func sendInvoice(sendInvoiceBody: SendInvoiceRequest, correlationsBody: Correlationset, portTypeBody: String, partnerLinkBody: String) async throws
}
