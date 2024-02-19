//
//  MessageParteResponse.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 16/02/24.
//

import Foundation

public struct MessagePartResponse: Codable {
    
    public var partId: String
    public var mimeType: String?
    public var filename: String?
    public var headers: [MessageHeaderResponse]?
    public var body: MessagePartBodyResponse?
    public var parts: [MessagePartResponse]?
}
