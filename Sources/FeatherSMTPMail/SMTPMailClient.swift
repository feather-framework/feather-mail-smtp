//
//  SMTPMailClient.swift
//  feather-smtp-mail
//
//  Created by gerp83 on 2026. 01. 17.
//

import Logging
import FeatherMail
import NIO
import NIOSMTP

/// A mail client implementation backed by SMTP.
///
/// `SMTPMailClient` is intended to be initialized once during server startup
/// and reused for the lifetime of the application. It validates mails,
/// encodes them into SMTP-compatible DATA payloads, and delivers them using
/// an internally managed SMTP client.
///
/// The client owns the underlying SMTP transport. Event loop group lifecycle
/// is managed by the provided `eventLoopGroup`.
public struct SMTPMailClient: MailClient, Sendable {

    private static let sharedEventLoopGroup: EventLoopGroup =
        MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

    /// Validator applied before encoding and delivery.
    private let validator: MailValidator

    /// Underlying SMTP client responsible for protocol communication.
    private let smtp: NIOSMTP

    /// Mail encoder provider used to build SMTP DATA payload encoders.
    private let mailEncoder: any MailEncoder

    /// Logger used for SMTP operations.
    private let logger: Logger

    /// Creates a new SMTP mail client.
    ///
    /// This initializer should typically be called during server startup.
    /// The resulting client instance is expected to live for the entire
    /// lifetime of the application.
    ///
    /// - Parameters:
    ///   - configuration: SMTP client configuration.
    ///   - mailEncoder: Optional provider used to create mail encoders.
    ///   - validator: Validator applied before delivery.
    ///   - eventLoopGroup: EventLoopGroup. Defaults to a shared instance.
    ///   - logger: Logger used for SMTP request and transport logging.
    init(
        configuration: Configuration,
        mailEncoder: any MailEncoder,
        validator: MailValidator = BasicMailValidator(),
        eventLoopGroup: EventLoopGroup = sharedEventLoopGroup,
        logger: Logger = .init(label: "feather.mail.smtp")
    ) {
        self.mailEncoder = mailEncoder
        self.validator = validator
        self.smtp = NIOSMTP(
            eventLoopGroup: eventLoopGroup,
            configuration: configuration,
            logger: logger
        )
        self.logger = logger
    }

    /// Sends a mail using SMTP.
    ///
    /// This method performs mail validation, SMTP DATA encoding, and
    /// delivery using the internally managed SMTP client.
    ///
    /// - Parameter email: The mail to send.
    /// - Throws: `MailError` if validation, encoding, or delivery fails.
    public func send(_ email: Mail) async throws(MailError) {
        do {
            try await validate(email)
        }
        catch {
            throw .validation(error)
        }
        do {
            let raw = try mailEncoder.encode(mail: email)
            let recipients = (email.to + email.cc + email.bcc).map(\.email)
            let envelope = try SMTPEnvelope(
                from: email.from.email,
                recipients: recipients,
                data: raw
            )
            try await smtp.send(envelope)
        }
        catch {
            throw mapSMTPError(error)
        }
    }

    /// Validates a mail using the configured validator.
    ///
    /// - Parameter mail: The mail to validate.
    /// - Throws: `MailValidationError` when validation fails.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        try await validator.validate(mail)
    }

    private func mapSMTPError(_ error: Error) -> MailError {
        guard let smtpError = error as? NIOSMTPError else {
            return .unknown(error)
        }

        if case let .custom(message) = smtpError {
            return .custom(message)
        }
        if case let .unknown(underlying) = smtpError {
            return .unknown(underlying)
        }
        return .unknown(smtpError)
    }
}
