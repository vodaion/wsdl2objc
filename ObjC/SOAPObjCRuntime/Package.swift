// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SOAPObjCRuntime",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "SOAPObjCRuntime", targets: ["SOAPObjCRuntime"]),
        .executable(name: "TemperatureConversionsObjCDemo", targets: ["TemperatureConversionsObjCDemo"]),
        .executable(name: "CountryInfoObjCDemo", targets: ["CountryInfoObjCDemo"]),
        .executable(name: "VIESObjCDemo", targets: ["VIESObjCDemo"]),
        .executable(name: "SessionEchoObjCDemo", targets: ["SessionEchoObjCDemo"]),
        .executable(name: "PurchaseOrderObjCDemo", targets: ["PurchaseOrderObjCDemo"]),
    ],
    targets: [
        .target(
            name: "SOAPObjCRuntime",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
            ]
        ),
        .testTarget(
            name: "SOAPObjCRuntimeTests",
            dependencies: ["SOAPObjCRuntime"]
        ),
        .executableTarget(
            name: "TemperatureConversionsObjCDemo",
            dependencies: ["SOAPObjCRuntime"],
            path: "Examples/TemperatureConversionsDemo"
        ),
        .executableTarget(
            name: "CountryInfoObjCDemo",
            dependencies: ["SOAPObjCRuntime"],
            path: "Examples/CountryInfoDemo"
        ),
        .executableTarget(
            name: "VIESObjCDemo",
            dependencies: ["SOAPObjCRuntime"],
            path: "Examples/VIESDemo"
        ),
        .executableTarget(
            name: "SessionEchoObjCDemo",
            dependencies: ["SOAPObjCRuntime"],
            path: "Examples/SessionEchoDemo"
        ),
        .executableTarget(
            name: "PurchaseOrderObjCDemo",
            dependencies: ["SOAPObjCRuntime"],
            path: "Examples/PurchaseOrderDemo"
        ),
    ]
)
