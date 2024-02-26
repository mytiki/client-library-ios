/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

// TokenRequestCallback protocol
public protocol TokenRequestCallback: AnyObject {
    static func onTokenReceived(_ accessToken: String)
    static func onTokenError()
    init()
}
