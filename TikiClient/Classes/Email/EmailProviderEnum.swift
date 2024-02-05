/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

/// Enum representing email providers.
public enum EmailProviderEnum: String, CaseIterable {
    /// Google email provider.
    case google = "GOOGLE"
    
    /// Outlook email provider.
    case outlook = "OUTLOOK"
    
    public func authorizationEndpoint() -> URL{
        switch(self) {
            case .google :
                return URL(string: "https://accounts.google.com/o/oauth2/v2/auth")!
            case .outlook :
                return URL(string: "https://login.microsoftonline.com/common/oauth2/v2.0/authorize")!
            
        }
    }
    
    public func tokenEndpoint() -> URL{
        switch(self) {
            case .google :
                return URL(string: "https://www.googleapis.com/oauth2/v4/token")!
            case .outlook :
                return URL(string: "https://login.microsoftonline.com/common/oauth2/v2.0/token")!
            
        }
    }
    public func userInfoEndpoint() -> String{
        switch(self) {
            case .google :
                return "https://openidconnect.googleapis.com/v1/userinfo"
            case .outlook :
                return "https://graph.microsoft.com/oidc/userinfo"
            
        }
    }
    public func deeplinkReturn() -> URL{
        switch(self) {
            case .google :
                return URL(string: "com.mytiki.TikiClient-Example:app-auth")!
            case .outlook :
                return URL(string:"msauth.com.mytiki.TikiClient-Example://auth")!
            
        }
    }
}
