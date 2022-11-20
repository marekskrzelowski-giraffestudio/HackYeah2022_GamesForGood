// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Persistence", targets: ["Persistence"])
    ],
    targets: [
        .target(name: "Persistence")
    ]
)
