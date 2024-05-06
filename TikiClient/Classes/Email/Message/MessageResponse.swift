/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public struct MessageResponse: Codable, Equatable {
      public var id: String
      public var threadId: String
      public var labelIds: [String]?
      public var snippet: String?
      public var historyId: String?
      public var internalDate: String?
      public var payload: MessagePartResponse?
      public var sizeEstimate: Int?
      public var raw: String?
    
    public static func == (lhs: MessageResponse, rhs: MessageResponse) -> Bool {
        return lhs.id == rhs.id
    }
}
