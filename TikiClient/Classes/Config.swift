/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

public struct Config {
    public var providerId: String
    public var publicKey: String
    public var companyName: String
    public var companyJurisdiction: String
    public var tosUrl: String
    public var privacyUrl: String
    
    public init(providerId: String, publicKey: String, companyName: String, companyJurisdiction: String, tosUrl: String, privacyUrl: String) {
        self.providerId = providerId
        self.publicKey = publicKey
        self.companyName = companyName
        self.companyJurisdiction = companyJurisdiction
        self.tosUrl = tosUrl
        self.privacyUrl = privacyUrl
    }
}
