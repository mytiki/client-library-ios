/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

public struct Config {
    var providerId: String
    var publicKey: String
    var companyName: String
    var companyJurisdiction: String
    var tosUrl: String
    var privacyUrl: String
    
    public init(providerId: String, publicKey: String, companyName: String, companyJurisdiction: String, tosUrl: String, privacyUrl: String) {
        self.providerId = providerId
        self.publicKey = publicKey
        self.companyName = companyName
        self.companyJurisdiction = companyJurisdiction
        self.tosUrl = tosUrl
        self.privacyUrl = privacyUrl
    }
}
