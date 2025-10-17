// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlinkEngage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BlinkEngage",
            targets: ["BlinkEngage", "BlinkEngageWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "12.11.0"),
        .package(url: "https://github.com/BlinkReceipt/blinkreceipt-ios.git", from: "1.62.0")
                       
    ],
    targets: [
        // Binary target - only distributes the compiled XCFramework
        .binaryTarget(
            name: "BlinkEngage",
            path: "BlinkEngage.xcframework"
        ),
        // Wrapper target to declare dependencies for the binary framework
        .target(
            name: "BlinkEngageWrapper",
            dependencies: [
                "BlinkEngage",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "BlinkReceipt", package: "blinkreceipt-ios")
            ],
            path: "BlinkEngageWrapper"
        )
    ]
)
