// swift-tools-version:5.7
/* Copyright © 2020 brian flagg <bflagg@acm.org>
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
 */

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





