// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChatBot",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ChatBot",
            targets: ["ChatBot"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios", .upToNextMajor(from: "4.5.0")),
        .package(url: "https://github.com/SDWebImage/SDWebImage", .upToNextMajor(from: "5.19.7"))
    ],
    targets: [
        .target(
            name: "ChatBot",
            dependencies: [
                .product(name: "SDWebImage", package: "sdwebimage"),
                .product(name: "Lottie", package: "lottie-ios")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
