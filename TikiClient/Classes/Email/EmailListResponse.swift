/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public struct EmailListResponse: Codable{
    public var messages: [MessageResponse]
    public var nextPageToken: String?
    public var resultSizeEstimate: Int?
}
