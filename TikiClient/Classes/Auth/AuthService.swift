/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation
import Security
import CryptoKit
import CryptoSwift


/// Authentication Service for TIKI
public class AuthService {

    public func address(providerId: String, userId: String, pubKey: String, completion: (String?) -> Void){
      let urlString = URL(string: "https://account.mytiki.com/api/latest/provider/\(providerId)/user")

      guard let accessToken = token(providerId, , completion: (String) -> Void) else {
        print("Error getting token")
        completion(nil)
      }

      guard let privateKey = KeyService.generate() else {
          print("Error generating private key")
          completion(nil)
      }
      
      let publicKey = SecKeyCopyPublicKey(privateKey)

      guard let address = KeyService.address(publicKey: publicKey) else {
          print("Error generating address")
          completion(nil)
      }

      let message = "\(userId).\(address.base64EncodedString())"

      guard let signature = signMessage(message: message, privateKey: keyPair.privateKey) else { 
        print("Error generating signature")
        completion(nil)
      }

      guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
        print("Error extracting Public Key Data")
        completion(nil)
      }

      let reqBody = AuthAddrRequest(id: userId, address: address.base64EncodedString().toUrlSafe(), pubKey: publicKeyData.base64EncodedString(), signature: signature.base64EncodedString())
      
      guard let jsonData = try? JSONEncoder().encode(body) else {
        print("Error encoding JSON")
        completion(nil)
      }

      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.httpBody = jsonData
      
      request.addValue("application/json", forHTTPHeaderField: "accept")
      request.addValue("application/json", forHTTPHeaderField: "content-type")
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
      
      URLSession.shared.dataTask(with: request) { (data, response, error) in
          if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
              print("########User registration successful")
              completion(address.base64EncodedString())
          } else {
              print("Error registering user. HTTP status: \(response?.description ?? "Unknown")")
              print("HTTP error! Body: \(String(describing: String(data: data!, encoding: .utf8)))")
              completion(nil)
          }
      }.resume()
      
    }
   
    public func token(providerId: String, clientSecret: String, completion: (String?) -> Void){
        var request = URLRequest(url: URL(string: "https://account.mytiki.com/api/latest/auth/token"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postData = "grant_type=client_credentials&client_id=provider:\(providerId.toUrlEncoded())&client_secret=\(clientSecret.toUrlEncoded())&scope=account:provider trail publish&expires=600"
        
        request.httpBody = postData.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {      
                
                guard let body = String(data: data, encoding: .utf8), error == nil, httpResponse = response as? HTTPURLResponse else {
                    print("Error fetching token: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP error! Status: \(httpResponse.statusCode), Body: \(body)")
                    completion(nil)
                    return
                }

               guard let responseData = try? JSONDecoder().decode(TokenResponse.self, from: data) else {
                    print("Error decoding JSON: \(body)")
                    completion(nil)
                    return
                }

                completion(responseData.access_token)
                
            }
        }.resume()

    }
}

