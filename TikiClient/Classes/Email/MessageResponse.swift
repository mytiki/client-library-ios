/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public struct MessageResponse: Codable {
    
      public var id: String
      public var threadId: String
      public var labelIds: [String]?
      public var snippet: String?
      public var historyId: String?
      public var internalDate: String?
      public var sizeEstimate: Int?
      public var raw: String?
    
}
