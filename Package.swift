// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Autofixtures",
    products: [
        .library(
            name: "Autofixtures",
            targets: ["Autofixtures"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Autofixtures",
            dependencies: []),
        .testTarget(
            name: "AutofixturesTests",
            dependencies: ["Autofixtures"]),
    ]
)
