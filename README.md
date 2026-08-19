# AuthLoggerSDK

A lightweight Swift package for sending authentication-related log events (sign-in failures, token errors, etc.) from an iOS app to the AuthLogger backend.

## Requirements

- iOS 13+
- Swift 6

## Installation

### Swift Package Manager

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/<your-org>/AuthLoggerSDK.git", from: "1.0.0"),
]
```

Or in Xcode: **File > Add Package Dependencies…** and enter the repository URL.

## Usage

### Configure

Call `configure(app:appVersion:)` once, typically at app launch, before logging any events:

```swift
import AuthLoggerSDK

AuthLoggerSDK.shared.configure(app: "MyApp", appVersion: "1.2.3")
```

### Log an event

```swift
AuthLoggerSDK.shared.log(
    severity: .error,
    message: "Sign-in failed",
    errorCode: "invalid_credentials",
    endpoint: "/auth/login",
    metadata: ["userId": "abc123", "attempt": 3]
)
```

`log(...)` returns a discardable `DataRequest` (from Alamofire) and accepts an optional completion handler:

```swift
AuthLoggerSDK.shared.log(
    severity: .warning,
    message: "Token refresh retried"
) { result in
    switch result {
    case .success:
        print("Event logged")
    case .failure(let error):
        print("Failed to log event: \(error)")
    }
}
```

### Severity levels

`AuthLogSeverity` supports: `debug`, `info`, `warning`, `error`, `critical`.

## What gets sent

Each event automatically includes:

- `platform` (always `"ios"`)
- `app` / `appVersion` (from `configure`)
- `osVersion` / `device` (collected automatically)
- `severity`, `message`, `errorCode`, `endpoint`
- `timestamp` (ISO 8601, set automatically)
- `metadata` (optional, arbitrary JSON-compatible dictionary)

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire) 5.9.0+
