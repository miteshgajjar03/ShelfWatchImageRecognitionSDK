// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShelfWatchImageRecognitionSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ShelfWatchImageRecognitionSDK",
            targets: ["ShelfWatchImageRecognitionSDK"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ShelfWatchImageRecognitionSDK",
            dependencies: [
                .target(name: "ShelfWatchImageRecognitionFramework")
            ]
        ),
        .testTarget(
            name: "ShelfWatchImageRecognitionSDKTests",
            dependencies: ["ShelfWatchImageRecognitionSDK"]
        ),
        .binaryTarget(
            name: "ShelfWatchImageRecognitionFramework",
            path: "./Sources/ShelfWatchImageRecognitionFramework.xcframework"
        )
    ]
)
