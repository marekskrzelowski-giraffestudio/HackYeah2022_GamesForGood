// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Interface",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Interface", targets: ["Interface"])
    ],
    dependencies: [
        .package(path: "../Packages/Content"),
        .package(path: "../Packages/Core"),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", exact: "0.1.4"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", exact: "6.5.10")
    ],
    targets: [
        .target(
            name: "Interface",
            dependencies: [
                "Content",
                "Core",
                .product(name: "Introspect", package: "SwiftUI-Introspect"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager")
            ]
        )
    ]
)
