/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

public struct AuthTokenResponse: Codable {
    public let auth: String
    public let refresh: String
    public let provider: String
    public let email: String
    public let expiration: Date?
    
    public init(auth: String, refresh: String, provider: String, email: String, expiration: Date?) {
        self.auth = auth
        self.refresh = refresh
        self.provider = provider
        self.email = email
        self.expiration = expiration
    }
}
