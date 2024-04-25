/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public struct MessagePartResponse: Codable {
    
    public var partId: String
    public var mimeType: String?
    public var filename: String?
    public var headers: [MessageHeaderResponse]?
    public var body: MessagePartBodyResponse?
    public var parts: [MessagePartResponse]?
}
