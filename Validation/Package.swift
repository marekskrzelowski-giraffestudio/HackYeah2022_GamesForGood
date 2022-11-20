// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Validation",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Validation", targets: ["Validation"])
    ],
    targets: [
        .target(name: "Validation")
    ]
)
