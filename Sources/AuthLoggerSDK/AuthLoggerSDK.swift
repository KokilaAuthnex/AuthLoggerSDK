// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Alamofire

/// Sends authentication-related log events to the AuthLogger backend.
public final class AuthLoggerSDK: @unchecked Sendable {
    public static let shared = AuthLoggerSDK()

    private static let eventsURL = "https://auth-logger-api.vercel.app/api/events"

    private let session: Session
    private var app: String = ""
    private var appVersion: String = ""

    init(session: Session = .default) {
        self.session = session
    }

    /// Must be called once (e.g. at app launch) before logging events.
    public func configure(app: String, appVersion: String) {
        self.app = app
        self.appVersion = appVersion
    }

    /// Builds and sends a log event to the AuthLogger API.
    @discardableResult
    public func log(
        severity: AuthLogSeverity,
        message: String,
        errorCode: String? = nil,
        endpoint: String? = nil,
        metadata: [String: Any]? = nil,
        completion: (@Sendable (Result<Void, AFError>) -> Void)? = nil
    ) -> DataRequest {
        precondition(!app.isEmpty, "AuthLoggerSDK.shared.configure(app:appVersion:) must be called before logging events")

        let event = AuthLogEvent(
            app: app,
            appVersion: appVersion,
            osVersion: DeviceInfo.osVersion,
            device: DeviceInfo.deviceModel,
            severity: severity,
            message: message,
            errorCode: errorCode,
            endpoint: endpoint,
            metadata: metadata
        )

        return session.request(
            Self.eventsURL,
            method: .post,
            parameters: event,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .response { response in
            completion?(response.result.map { _ in () })
        }
    }
}
