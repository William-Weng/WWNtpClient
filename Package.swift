// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWNtpClient",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWNtpClient", targets: ["WWNtpClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWTcpConnection", from: "1.0.3")
    ],
    targets: [
        .target(name: "WWNtpClient", dependencies: ["WWTcpConnection"], resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
