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
   var signature: String
   let expiry: String? = nil
}


