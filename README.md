# Feather Mail Driver SMTP

SMTP-backed mail driver for Feather Mail using SwiftNIO.

![Release: 1.0.0-beta.1](https://img.shields.io/badge/Release-1%2E0%2E0--beta%2E1-F05138)

## Features

- SMTP delivery over SwiftNIO
- Raw MIME encoding via Feather Mail
- Supports text, HTML, and attachments
- Optional auth and STARTTLS

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: macOS, iOS, tvOS, watchOS, visionOS](https://img.shields.io/badge/Platforms-macOS_%7C_iOS_%7C_tvOS_%7C_watchOS_%7C_visionOS-F05138)

- Swift 6.1+
- Platforms:
    - macOS 13+
    - iOS 16+
    - tvOS 16+
    - watchOS 9+
    - visionOS 1+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-mail-driver-smtp", .upToNextMinor(from: "1.0.0-beta.1")),
```

Then add `FeatherMailDriverSMTP` to your target dependencies:

```swift
.product(name: "FeatherMailDriverSMTP", package: "feather-mail-driver-smtp"),
```

## Usage

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Related repositories

- [Feather Mail](https://github.com/feather-framework/feather-mail)
- [SwiftNIO SMTP](https://github.com/BinaryBirds/swift-nio-smtp)
- [Feather Mail Driver SES](https://github.com/feather-framework/feather-mail-driver-ses)

## Development

- Build: `swift build`
- Test:
    - local: `make test`
    - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-mail-driver-smtp/pulls) are welcome. Please keep changes focused and include tests for new logic.
