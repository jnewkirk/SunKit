// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SunKit",
    platforms: [.macOS(.v12), .iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SunKit",
            targets: ["SunKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jnewkirk/SwiftAA", from: "2.4.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.59.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SunKit",
            dependencies: ["SwiftAA"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "SunKitTests",
            dependencies: ["SunKit", "SwiftAA"],
            resources: [.copy("TestData/testSolarData.json"), .copy("TestData/testLunarData.json"), .copy("TestData/waypoints.json")]
        ),
    ]
)
