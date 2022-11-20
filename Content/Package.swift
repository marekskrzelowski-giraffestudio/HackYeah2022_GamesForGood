// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Content",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Content", targets: ["Content"])
    ],
    targets: [
        .target(name: "Content")
    ]
)
