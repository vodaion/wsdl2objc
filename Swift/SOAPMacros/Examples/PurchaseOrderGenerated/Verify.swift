// Build-time verification that the emitter's multi-part body output compiles
// against SOAPMacros. PurchaseOrder.swift is a verbatim copy of `make
// swift-purchase` output, refreshed by `make swift-verify` from repo root.
//
// Exercises:
//   * input messages with multiple <part> children (4 parts each)
//   * mixed SOAPCodable + xs:string body parts
//   * operations with no <output> (one-way)
//   * operations whose output message has no <part> (void return)

import Foundation
import SOAPMacros

@main
struct VerifyGenerated {
    static func main() async throws {
        let service = ListenerServiceService()
        try await service.sendMyPurchaseOrder(
            sendPurchaseOrderBody: SendPORequest(customerId: 1, purchaseOrderNumber: 2, productId: 3, quantity: 4),
            correlationsBody: Correlationset(purchaseOrder: Correlationsetvalues(purchaseOrderNumber: "P", customerID: "C")),
            portTypeBody: "purchaseOrderPortType",
            partnerLinkBody: "buyer"
        )
        try await service.sendMySchedule(
            sendScheduleBody: SendScheduleRequest(shipDate: Date(), customerId: 1, purchaseOrderNumber: 2),
            correlationBody: Correlationset(purchaseOrder: Correlationsetvalues(purchaseOrderNumber: "P", customerID: "C")),
            portTypeBody: "purchaseOrderPortType",
            partnerLinkBody: "buyer"
        )
        try await service.sendInvoice(
            sendInvoiceBody: SendInvoiceRequest(price: 9.99, customerId: 1, purchaseOrderNumber: 2),
            correlationsBody: Correlationset(purchaseOrder: Correlationsetvalues(purchaseOrderNumber: "P", customerID: "C")),
            portTypeBody: "purchaseOrderPortType",
            partnerLinkBody: "buyer"
        )
    }
}
