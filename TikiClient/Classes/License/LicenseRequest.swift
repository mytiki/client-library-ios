/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import Foundation

public struct LicenseRequest : Codable {
   let ptr: String
   let tags: [String]
   let uses: [Use]
   let terms: String
   let description: String
   let origin: String
   let expiry: String?
   var signature: String?
    
    public init(ptr: String, tags: [String], uses: [Use], terms: String, description: String, origin: String, expiry: String?, signature: String?) {
        self.ptr = ptr
        self.tags = tags
        self.uses = uses
        self.terms = terms
        self.description = description
        self.origin = origin
        self.expiry = expiry
        self.signature = signature
    }
}


