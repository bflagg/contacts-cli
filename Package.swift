// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "321Contacts",
    platforms: [ .macOS(.v10_15) ],     // minimum for async/await
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(name: "contacts", dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser") ] )
    ]
)





