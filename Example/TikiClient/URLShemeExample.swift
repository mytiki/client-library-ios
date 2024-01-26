/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation
import UIKit
import TikiClient

extension UIApplicationDelegate {
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
           scheme.localizedCaseInsensitiveCompare("msauth.com.mytiki") == .orderedSame,
           scheme.localizedCaseInsensitiveCompare("com.mytiki") == .orderedSame,
           let view = url.host {
            
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            switch url.host {
            case "email":
                EmailService.continueOauthlogin(url: url)
            default:
                print("Deeplink error")
            }
        }
        return true
    }
}
