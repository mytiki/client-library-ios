/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

 

public struct EmailOauthResponse : Codable{
    public var sub: String
    public var name: String
    public var given_name: String
    public var family_name: String
    public var picture: String
    public var email: String
    public var email_verified: Bool
    public var locale: String?
}
