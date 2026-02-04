// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "app-core-packages",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
        .library(
            name: "DomainMock",
            targets: ["DomainMock"]
        ),
        .library(
            name: "Data",
            targets: ["Data"]
        ),
        .library(
            name: "DataMock",
            targets: ["DataMock"]
        ),
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
        .library(
            name: "LocalPersistance",
            targets: ["LocalPersistance"]
        ),
        .library(
            name: "LocalPersistanceMock",
            targets: ["LocalPersistanceMock"]
        ),
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [],
            path: "Domain/Sources/Domain"
        ),
        .target(
            name: "DomainMock",
            dependencies: ["Domain"],
            path: "Domain/Sources/DomainMock"
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain", "DomainMock"],
            path: "Domain/Tests/DomainTests"
        ),
        .target(
            name: "Data",
            dependencies: ["Domain", "Networking"],
            path: "Data/Sources/Data"
        ),
        .target(
            name: "DataMock",
            dependencies: ["Data"],
            path: "Data/Sources/DataMock"
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data", "DataMock"],
            path: "Data/Tests/DataTests"
        ),
        .target(
            name: "Networking",
            dependencies: [],
            path: "Networking/Sources/Networking"
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            path: "Networking/Tests/NetworkingTests"
        ),
        .target(
            name: "LocalPersistance",
            dependencies: [
                .product(name: "SwiftKeychainWrapper", package: "SwiftKeychainWrapper")
            ],
            path: "LocalPersistance/Sources/LocalPersistance"
        ),
        .target(
            name: "LocalPersistanceMock",
            dependencies: ["LocalPersistance"],
            path: "LocalPersistance/Sources/LocalPersistanceMock"
        ),
        .testTarget(
            name: "LocalPersistanceTests",
            dependencies: ["LocalPersistance", "LocalPersistanceMock"],
            path: "LocalPersistance/Tests/LocalPersistanceTests"
        ),
        .target(
            name: "DesignSystem",
            dependencies: [],
            path: "DesignSystem/Sources/DesignSystem",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"],
            path: "DesignSystem/Tests/DesignSystemTests"
        )
    ]
)
