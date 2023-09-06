//
//  Main.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/09/06.
//

import Foundation
import APNSCore
import APNS

struct Main {
    static let deviceToken = "4fb4dac791d2c13ea9fbc5ca0b8ff0708c961cfb95b7f6fb9eb5889beeb2a037"
    static let appBundleID = "messagekitid.ChatStudyApp"
    static let privateKey = """
    -----BEGIN PRIVATE KEY-----
    MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgCud3onc6/z2a6xO3
    i2sO4AbiTATq/+RAo6TMfsDi3CWgCgYIKoZIzj0DAQehRANCAATXVkjqndBbtYaY
    2NDwDQGwFyAstO8y+XdvXq0fk6BEm8evlNlpnEGV35IBivW8wdRDZWrEIiRzscRw
    HJ8anVKl
    -----END PRIVATE KEY-----
    """
    static let keyIdentifier = "HT5Y75T2AR"
    static let teamIdentifier = "N2WW86KJNF"
    
    static func main() async throws {
        let client = APNSClient(
            configuration: .init(
                authenticationMethod: .jwt(
                    privateKey: try .init(pemRepresentation: privateKey),
                    keyIdentifier: keyIdentifier,
                    teamIdentifier: teamIdentifier
                ),
                environment: .sandbox
            ),
            eventLoopGroupProvider: .createNew,
            responseDecoder: JSONDecoder(),
            requestEncoder: JSONEncoder()
        )

        try await Self.sendSimpleAlert(with: client)
        client.shutdown { _ in
            
        }
    }
}

extension Main {
    static func sendSimpleAlert(with client: some APNSClientProtocol) async throws {
        try await client.sendAlertNotification(
            .init(
                alert: .init(
                    title: .raw("Simple Alert"),
                    subtitle: .raw("Subtitle"),
                    body: .raw("Body"),
                    launchImage: nil
                ),
                expiration: .immediately,
                priority: .immediately,
                topic: self.appBundleID,
                payload: EmptyPayload()
            ),
            deviceToken: self.deviceToken
        )
    }
}
