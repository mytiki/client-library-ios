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

    public func registerAddress(userId: String, providerId: String, pubKey: String, completion: @escaping (_ sucess: String?, _ error: String?) -> Void) {
        let urlString = URL(string: "https://account.mytiki.com/api/latest/provider/\(providerId)/user")
        
        token(providerId: providerId, secret: pubKey, scopes: ["account:provider"], address: nil, completion: { token, error  in
            guard let accessToken = token else{
                completion(nil, "Error getting token")
                return
            }
            
            guard let privateKey = KeyService.generate() else {
                completion(nil, "Error generating private key")
                return
            }
            
            guard let publicKeyB64 = KeyService.publicKeyB64(privateKey: privateKey) else{
                completion(nil, "Error extracting public key")
                return
            }

            guard let address = KeyService.address(b64PubKey: publicKeyB64) else {
                completion(nil, "Error generating address")
                return
            }

            let message = "\(userId).\(address)"
            
            guard let signature = KeyService.sign(message: message, privateKey: privateKey) else {
                completion(nil, "Error generating signature")
                return
            }
            
            let reqBody = AuthAddrRequest(id: userId, address: address, pubKey: publicKeyB64, signature: signature)
            
            guard let jsonData = try? JSONEncoder().encode(reqBody) else {
                completion(nil, "Error encoding JSON")
                return
            }
            
            var request = URLRequest(url: urlString!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(address, nil)
                    let privKeyData = SecKeyCopyExternalRepresentation(privateKey, nil)! as Data
                    KeyService.save(privKeyData, service: providerId, key: userId)
                } else {
                    completion(nil, "Error registering user. HTTP status: \(response?.description ?? "Unknown")")
                }
            }.resume()
            
        })
    }
        
    public func token(providerId: String, secret: String, scopes: [String], address: String? = nil,  completion: @escaping (_ sucess: String?, _ error: String?) -> Void){
        var request = URLRequest(url: URL(string: "https://account.mytiki.com/api/latest/auth/token")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if(address != nil){
            
        }

        let provider = address == nil ? "provider:\(providerId)" : "addr:\(providerId):\(address!.base64UrlSafe())"
        let scopesJoined = scopes.joined(separator: " ")
        let slashedSecret = secret.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let postData = "grant_type=client_credentials&client_id=\(provider)&client_secret=\(slashedSecret)&scope=\(scopesJoined)&expires=600"
        
        request.httpBody = postData.data(using: .utf8)
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                
                guard let body = String(data: data!, encoding: .utf8),
                        let httpResponse = response as? HTTPURLResponse,
                        error == nil else {
                    completion(nil, "Error fetching token: \(error?.localizedDescription ?? "Unknow")")
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, "HTTP error! Status: \(httpResponse.statusCode), Body: \(body)")
                    return
                }
                
                guard let responseData = try? JSONDecoder().decode(AuthTokenResponse.self, from: data!) else {
                    completion(nil, "Error decoding JSON: \(body)")
                    return
                }
                
                completion(responseData.access_token, nil)
                
            }
        }.resume()
        
    }

}


