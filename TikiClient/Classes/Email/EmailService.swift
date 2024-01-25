/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation
import AppAuth

/// Service for managing email accounts.
public class EmailService {

    
    static var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    private var authState: OIDAuthState?
    public func setAuthState(_ state: OIDAuthState?){
        authState = state
    }
    
    public init(){}

    /// Logs in a user account using the provided credentials or initiates OAuth authentication for Gmail.
    ///
    /// - Parameters:
    ///   - account: An instance of the Account class containing user and account information.
    ///   - onError: A closure to handle error messages.
    ///   - onSuccess: A closure to handle success actions.
    public func login(_ provider:EmailProviderEnum, _ clientID: String, _ clientSecret: String = "") {

        let configuration = OIDServiceConfiguration(
            authorizationEndpoint: provider.authorizationEndpoint(),
            tokenEndpoint: provider.tokenEndpoint())
        let redirectURI = URL(string: "com.mytiki.TikiClient-Example:app-auth")!
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)

        // performs authentication request
        print("Initiating authorization request with scope: \(request.scope ?? "nil")")

        EmailService.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
            
          if let authState = authState {
            self.setAuthState(authState)
              let authToken = AuthToken(auth: (authState.lastTokenResponse?.accessToken) ?? "", refresh: authState.lastTokenResponse?.refreshToken, expiration: authState.lastTokenResponse?.accessTokenExpirationDate)
            
            
            // Get User Email Information
            
            let userinfoEndpoint = URL(string:provider.userInfoEndpoint())!

              // Add Bearer token to request
              var urlRequest = URLRequest(url: userinfoEndpoint)
              urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(authToken.auth)"]

              URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                  guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                      print(response)
                      return
                  }
                  do{
                      let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                  }catch{
                      print("error")
                  }
                  
                  
                  let dataReceived = String(data: data!, encoding: .utf8)
                  let decoder = JSONDecoder()
                  let body = dataReceived?.data(using: .utf8)
                  let emailOauthResponse = try! decoder.decode(EmailOauthResponse.self, from: body!)


                  EmailRepository.SaveEmailToken(authToken: authToken, email: emailOauthResponse.email)
                  
              }.resume()
              
              
            
              
            print("Got authorization tokens. Access token: " +
                  "\(authState.lastTokenResponse?.accessToken ?? "nil")")
          } else {
            print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
            self.setAuthState(nil)
          }
        }
        
    }

    /// Continue the OAuth authentication
    ///
    /// - Parameter provider: The email provider (GOOGLE or OUTLOOK).
    public static func continueOauthlogin(url: URL) {
        currentAuthorizationFlow?.resumeExternalUserAgentFlow(with: url)
        currentAuthorizationFlow = nil
    }

    /// Retrieves the list of connected email accounts.
    ///
    /// - Returns: List of connected email accounts.
    public func accounts() -> [String] {
        return []
    }

    /// Removes a previously added email account.
    ///
    /// - Parameter email: The email account to be removed.
    public func logout(email: String) {
        // Implementation
    }
}
