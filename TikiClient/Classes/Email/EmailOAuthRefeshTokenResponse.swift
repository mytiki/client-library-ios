/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */
import Foundation

public struct EmailOauthRefeshTokenResponse : Codable{
    public var access_token: String
    public var expires_in: Int
    public var scope: String
    public var token_type: String
    public var id_token: String
}
