import Foundation

public enum AuthLogSeverity: String, Codable, Sendable {
    case debug
    case info
    case warning
    case error
    case critical
}

public struct AuthLogEvent: Codable, Sendable {
    public let platform: String
    public let app: String
    public let appVersion: String
    public let osVersion: String
    public let device: String
    public let severity: AuthLogSeverity
    public let message: String
    public let errorCode: String?
    public let endpoint: String?
    public let timestamp: String
    public let metadata: [String: AnyCodable]?

    public init(
        platform: String = "ios",
        app: String,
        appVersion: String,
        osVersion: String,
        device: String,
        severity: AuthLogSeverity,
        message: String,
        errorCode: String? = nil,
        endpoint: String? = nil,
        timestamp: Date = Date(),
        metadata: [String: Any]? = nil
    ) {
        self.platform = platform
        self.app = app
        self.appVersion = appVersion
        self.osVersion = osVersion
        self.device = device
        self.severity = severity
        self.message = message
        self.errorCode = errorCode
        self.endpoint = endpoint
        self.timestamp = ISO8601DateFormatter().string(from: timestamp)
        self.metadata = metadata.map { $0.mapValues { AnyCodable($0) } }
    }
}
