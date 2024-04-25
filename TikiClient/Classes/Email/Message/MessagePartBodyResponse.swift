/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */



import Foundation

public struct MessagePartBodyResponse: Codable {
    public var attachmentId: String?
    public var size: Int?
    public var data: String?
}
