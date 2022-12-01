// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccessTracker",
    platforms: [.macOS(.v10_15), .iOS(.v14)],
    products: [
        .library(
            name: "AccessTracker",
            targets: ["AccessTracker"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/GoodHatsLLC/Disposable.git", .upToNextMajor(from: "0.1.0")),
    ],
    targets: [
        .target(
            name: "AccessTracker",
            dependencies: [
                "Disposable",
            ]
        ),
        .testTarget(
            name: "AccessTrackerTests",
            dependencies: ["AccessTracker"]
        ),
    ]
)
