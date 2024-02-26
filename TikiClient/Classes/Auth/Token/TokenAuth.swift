/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

class TokenAuth {

    func generateToken(providerId: String, publicKey: String) {
        TokenRequestTask.execute(providerId: providerId, pubKey: publicKey)
    }

    // TokenRequestCallback methods
    func onTokenReceived(_ accessToken: String) {
        // Handle the received token
        print("Received Access Token: \(accessToken)")
    }

    func onTokenError() {
        // Handle token request error
        print("Error fetching token")
    }
}
