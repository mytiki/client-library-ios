//
//  UserAddressRequest.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 26/02/24.
//

import Foundation

public struct UserAddressRequest: Codable {
    public let id: String
    public let address: String
    public let pubKey: String
    public let signature: String
}
