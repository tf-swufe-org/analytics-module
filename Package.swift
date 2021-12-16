// swift-tools-version:5.3
import PackageDescription

let isLocalTestMode = true

var deps: [Package.Dependency] = [
    .package(url: "https://github.com/tomlee130/feather-core", .branch("main")),//from: "1.0.0-beta"),
    .package(url: "https://github.com/malcommac/UAParserSwift", from: "1.2.1"),
    .package(name: "ALanguageParser", url: "https://github.com/matsoftware/accept-language-parser", from: "1.0.0"),
    .package(url: "https://github.com/vapor/sql-kit.git", from: "3.0.0"),
]

var targets: [Target] = [
    .target(name: "AnalyticsApi"),
    .target(name: "AnalyticsModule", dependencies: [
        .product(name: "FeatherCore", package: "feather-core"),
        .product(name: "UAParserSwift", package: "UAParserSwift"),
        .product(name: "ALanguageParser", package: "ALanguageParser"),
        .product(name: "SQLKit", package: "sql-kit"),
        .target(name: "AnalyticsApi")
    ],
    resources: [
        .copy("Bundle"),
    ]),
]

// @NOTE: https://bugs.swift.org/browse/SR-8658
if isLocalTestMode {
    deps.append(contentsOf: [
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.2.0"),
    ])
    targets.append(contentsOf: [
        .target(name: "Feather", dependencies: [
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
            .target(name: "AnalyticsModule"),
        ]),
        .testTarget(name: "AnalyticsModuleTests", dependencies: [
            .target(name: "AnalyticsModule"),
            .product(name: "FeatherTest", package: "feather-core")
        ])
    ])
}

let package = Package(
    name: "analytics-module",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "AnalyticsModule", targets: ["AnalyticsModule"]),
    ],
    dependencies: deps,
    targets: targets
)
