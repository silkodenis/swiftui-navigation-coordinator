// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavigationCoordinator",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "NavigationCoordinator",
            targets: ["NavigationCoordinator"]),
    ],
    targets: [
            .target(
                name: "NavigationCoordinator",
                path: "Sources/NavigationCoordinator",
                exclude: ["../../TestApp"]
            ),
            .testTarget(
                name: "NavigationCoordinatorTests",
                dependencies: ["NavigationCoordinator"],
                path: "Tests/NavigationCoordinatorTests"
            ),
        ]
)
