// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LOLAPIClient",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LOLAPIClient",
            targets: ["LOLAPIClient"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LOLAPIClient",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
            ]),
        .testTarget(
            name: "LOLAPIClientTests",
            dependencies: [
                "LOLAPIClient",
                .product(name: "XCTVapor", package: "vapor"),
                // Workaround for https://github.com/apple/swift-package-manager/issues/6940
                .product(name: "Vapor", package: "vapor"),
            ]),
    ]
)
