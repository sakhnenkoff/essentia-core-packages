# App Core Packages

Shared Swift packages for iOS apps. This repo exposes a single multi-product Swift package that groups the core modules.

## Packages

- Domain: Entities and repository protocols
- Data: Repository implementations (depends on Domain + Networking)
- Networking: API request/response handling
- LocalPersistance: Keychain and UserDefaults caching
- DesignSystem: UI components, colors, typography, resources

## Requirements

- Swift 5.9+ (tools 6.0)
- iOS 18.0+

## Installation (SPM)

Package.swift example:

```swift
dependencies: [
    .package(url: "https://github.com/sakhnenkoff/app-core-packages.git", from: "1.0.0")
]
```

Add products to targets:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "Domain", package: "AppCorePackages"),
        .product(name: "Data", package: "AppCorePackages"),
        .product(name: "Networking", package: "AppCorePackages"),
        .product(name: "LocalPersistance", package: "AppCorePackages"),
        .product(name: "DesignSystem", package: "AppCorePackages")
    ]
)
```

Xcode: File > Add Packages... then use the repo URL.

## Local Override (Development)

In Xcode, use File > Packages > Add Local... and point to a local clone of this repo. Xcode will prefer the local package while you iterate.

## Development

```bash
swift build
swift test
```

## Release

1. Update code and tests
2. Run `swift test`
3. Tag and push: `git tag x.y.z && git push --tags`
