// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Charty",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Charty", targets: ["Charty"]),
    ],
    dependencies: [
        .package(url: "https://github.com/philprime/Cabinet", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "2.2.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "8.0.7"))
    ],
    targets: [
        .target(name: "Charty", dependencies: [
            .product(name: "CabinetPartialTypes", package: "Cabinet")
        ]),
        .testTarget(name: "ChartyTests", dependencies: ["Charty", "Quick", "Nimble"]),
    ]
)
