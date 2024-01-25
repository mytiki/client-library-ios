/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

/// Authentication Service for TIKI
public class AuthService {

    /// Authenticates with TIKI and saves the auth and refresh tokens.
    ///
    /// - Parameters:
    ///   - publishingId: The TIKI Publishing ID.
    ///   - userId: The user identification.
    /// - Returns: The authentication token.
    public func authenticate(publishingId: String, userId: String) -> String {
        return ""
    }

    public static func saveAuthToken(token: String, service: String){
        //TODO
    }
    /// Retrieves the authentication token, refreshing if necessary.
    ///
    /// - Returns: The authentication token.
    public func token() -> String {
        return ""
    }

    /// Revokes the authentication token.
    public func revoke() {
        // Implementation
    }

    /// Refreshes the authentication token.
    ///
    /// - Returns: The updated authentication token.
    public func refresh() -> String {
        return ""
    }
}
