//
//  EmailOAuthRefeshTokenResponse.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 30/01/24.
//

import Foundation

public struct EmailOauthRefeshTokenResponse : Codable{
    public var access_token: String
    public var expires_in: Int
    public var scope: String
    public var token_type: String
    public var id_token: String
}
