//
//  MessagePartBodyResponse.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 16/02/24.
//

import Foundation

public struct MessagePartBodyResponse: Codable {
    public var attachmentId: String?
    public var size: Int?
    public var data: String?
}
