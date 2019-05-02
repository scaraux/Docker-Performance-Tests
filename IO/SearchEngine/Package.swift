// swift-tools-version:5.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SearchEngine",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/scaraux/Swift-Porter-Stemmer-2", from: "0.1.1"),
        .package(url: "https://github.com/davecom/SwiftPriorityQueue", from: "1.2.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SearchEngine",
            dependencies: ["PorterStemmer2", "SwiftPriorityQueue"]),
    ]
)
