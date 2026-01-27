// swift-tools-version:6.1
import PackageDescription

// NOTE: https://github.com/swift-server/swift-http-server/blob/main/Package.swift
var defaultSwiftSettings: [SwiftSetting] = [
    
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0441-formalize-language-mode-terminology.md
    .swiftLanguageMode(.v6),
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("MemberImportVisibility"),
    // https://forums.swift.org/t/experimental-support-for-lifetime-dependencies-in-swift-6-2-and-beyond/78638
    .enableExperimentalFeature("Lifetimes"),
    // https://github.com/swiftlang/swift/pull/65218
    .enableExperimentalFeature("AvailabilityMacro=FeatherMailAvailability:macOS 13, iOS 16, watchOS 9, tvOS 16, visionOS 1"),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif

let package = Package(
    name: "feather-mail-driver-smtp",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "FeatherMailDriverSMTP", targets: ["FeatherMailDriverSMTP"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.0.0"),
        //.package(url: "https://github.com/feather-framework/feather-mail", .upToNextMinor(from: "0.5.0")),
        .package(path: "../feather-mail"),
        .package(path: "../swift-nio-smtp"),
    ],
    targets: [
        .target(
            name: "FeatherMailDriverSMTP",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "NIOSMTP", package: "swift-nio-smtp"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .testTarget(
            name: "FeatherMailDriverSMTPTests",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "FeatherMailDriverSMTP"),
            ]
        ),
    ]
)
