// swift-tools-version: 5.10
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SOAPMacros",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "SOAPMacros", targets: ["SOAPMacros"]),
        .library(name: "SOAPRuntime", targets: ["SOAPRuntime"]),
        .executable(name: "TemperatureConversionsDemo", targets: ["TemperatureConversionsDemo"]),
        .executable(name: "TemperatureConversionsGeneratedDemo", targets: ["TemperatureConversionsGeneratedDemo"]),
        .executable(name: "CountryInfoDemo", targets: ["CountryInfoDemo"]),
        .executable(name: "SessionEchoGeneratedDemo", targets: ["SessionEchoGeneratedDemo"]),
        .executable(name: "PurchaseOrderGeneratedDemo", targets: ["PurchaseOrderGeneratedDemo"]),
        .executable(name: "VIESDemo", targets: ["VIESDemo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0"),
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.17.1"),
    ],
    targets: [
        .target(
            name: "SOAPRuntime",
            dependencies: [
                .product(name: "XMLCoder", package: "XMLCoder"),
            ]
        ),
        .macro(
            name: "SOAPMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .target(
            name: "SOAPMacros",
            dependencies: ["SOAPMacrosPlugin", "SOAPRuntime"],
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .executableTarget(
            name: "TemperatureConversionsDemo",
            dependencies: ["SOAPMacros", "SOAPRuntime"],
            path: "Examples/TemperatureConversionsDemo",
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .executableTarget(
            name: "TemperatureConversionsGeneratedDemo",
            dependencies: ["SOAPMacros", "SOAPRuntime"],
            path: "Examples/TemperatureConversionsGenerated",
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .executableTarget(
            name: "CountryInfoDemo",
            dependencies: ["SOAPMacros", "SOAPRuntime"],
            path: "Examples/CountryInfoDemo",
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .executableTarget(
            name: "SessionEchoGeneratedDemo",
            dependencies: ["SOAPMacros", "SOAPRuntime"],
            path: "Examples/SessionEchoGenerated",
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .executableTarget(
            name: "PurchaseOrderGeneratedDemo",
            dependencies: ["SOAPMacros", "SOAPRuntime"],
            path: "Examples/PurchaseOrderGenerated",
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .executableTarget(
            name: "VIESDemo",
            dependencies: ["SOAPMacros", "SOAPRuntime"],
            path: "Examples/VIESDemo",
            swiftSettings: [
                .enableExperimentalFeature("BodyMacros"),
            ]
        ),
        .testTarget(
            name: "SOAPMacrosTests",
            dependencies: [
                "SOAPMacrosPlugin",
                "SOAPRuntime",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
