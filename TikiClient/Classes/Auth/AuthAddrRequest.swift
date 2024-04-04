/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public struct AuthAddrRequest: Codable {
    public let id: String
    public let address: String
    public let pubKey: String
    public let signature: String
}
