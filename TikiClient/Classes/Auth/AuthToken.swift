//
//  AuthToken.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 23/01/24.
//

import Foundation

public struct AuthToken: Codable {
    public let auth: String
    public let refresh: String?
    public let expiration: Date?
    
    public init(auth: String, refresh: String?, expiration: Date?) {
        self.auth = auth
        self.refresh = refresh
        self.expiration = expiration
    }
}
