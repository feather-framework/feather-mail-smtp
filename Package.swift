// swift-tools-version:6.3
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .swiftLanguageMode(.v6),
    .strictMemorySafety(),
    .treatAllWarnings(as: .error),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("ImmutableWeakCaptures"),
    .enableExperimentalFeature("SuppressedAssociatedTypes"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableExperimentalFeature("Lifetimes"),
    .enableUpcomingFeature("StrictConcurrency"),
]

let package = Package(
    name: "feather-mail-smtp",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "FeatherMailSMTP", targets: ["FeatherMailSMTP"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.14.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.0.0"),
        .package(
            url: "https://github.com/BinaryBirds/swift-nio-smtp",
            .upToNextMinor(from: "1.0.0-beta.1")
        ),
        .package(
            url: "https://github.com/feather-framework/feather-mail",
            exact: "1.0.0-rc.3"
        ),
    ],
    targets: [
        .target(
            name: "FeatherMailSMTP",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .product(name: "NIOSMTP", package: "swift-nio-smtp"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "Logging", package: "swift-log"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FeatherMailSMTPTests",
            dependencies: [
                .product(name: "FeatherMail", package: "feather-mail"),
                .target(name: "FeatherMailSMTP"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
