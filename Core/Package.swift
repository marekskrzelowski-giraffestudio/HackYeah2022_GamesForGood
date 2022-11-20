// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        .package(path: "../Packages/Networking"),
        .package(path: "../Packages/Persistence"),
        .package(path: "../Packages/Validation"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Networking",
                "Persistence",
                "Validation",
            ]
        )
    ]
)
