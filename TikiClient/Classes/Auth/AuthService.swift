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

    public func address(providerId: String, userId: String, pubKey: String, completion: @escaping (String?) -> Void) {
        let urlString = URL(string: "https://account.mytiki.com/api/latest/provider/\(providerId)/user")
        
        token(providerId: providerId, secret: pubKey, scopes: ["aa"], address: nil, completion: { token in
            guard let accessToken = token else{
                print("Error getting token")
                completion(nil)
                return
            }
            
            guard let privateKey = KeyService.generate() else {
                print("Error generating private key")
                completion(nil)
                return
            }

            guard let internalPrivKey = SecKeyCopyPublicKey(privateKey),
                let publicKeyData = SecKeyCopyExternalRepresentation(internalPrivKey, nil) as Data? else {
                    print("Error extracting Public Key Data")
                    completion(nil)
                    return
                    }
            
            let keySize = 256
            let exportImportManager = CryptoExportImportManager()
            let publicKeyB64 = exportImportManager.exportPublicKeyToPEM(publicKeyData, keySize: keySize)!

            guard let address = KeyService.address(b64PubKey: publicKeyB64) else {
                print("Error generating address")
                completion(nil)
                return
            }

            let message = "\(userId).\(address.base64EncodedString().base64UrlEncoding())"
            
            guard let signature = KeyService.sign(message: message, privateKey: privateKey) else {
                print("Error generating signature")
                completion(nil)
                return
            }
            
            let reqBody = AuthAddrRequest(id: userId, address: address.base64EncodedString().base64UrlEncoding(), pubKey: publicKeyB64, signature: signature.base64EncodedString())
            
            guard let jsonData = try? JSONEncoder().encode(reqBody) else {
                print("Error encoding JSON")
                completion(nil)
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
                    print("########User registration successful")
                    completion(address.base64EncodedString())
                    
                } else {
                    print("Error registering user. HTTP status: \(response?.description ?? "Unknown")")
                    print("HTTP error! Body: \(String(describing: String(data: data!, encoding: .utf8)))")
                    completion(nil)
                    
                }
            }.resume()
            
        })
    }
        
    public func token(providerId: String, secret: String, scopes: [String], address: String?,  completion: @escaping (String?) -> Void){
        var request = URLRequest(url: URL(string: "https://account.mytiki.com/api/latest/auth/token")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if(address != nil){
            
        }
        
        var data = URLComponents()
        data.queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials"),
            URLQueryItem(name: "client_id", value: address == nil ? "provider:\(providerId)" : "addr:\(providerId):\(address!)"),
            URLQueryItem(name: "client_secret", value: secret.base64UrlEncoding()),
            URLQueryItem(name: "scope", value: "account:provider trail publish".base64UrlEncoding()),
            URLQueryItem(name: "expires", value: "600")
        ]
        
        var provider = address == nil ? "provider:\(providerId.base64UrlEncoding())" : "addr:\(providerId.urlEncoded().base64UrlEncoding()):\(address!.urlEncoded().base64UrlEncoding())"

        let postData = "grant_type=client_credentials&client_id=\(provider)&client_secret=\(secret.base64UrlEncoding())&scope=account:provider trail publish&expires=600"
        
        print(postData)
        
        request.httpBody = postData.data(using: .utf8)
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                
                guard let body = String(data: data!, encoding: .utf8),
                        let httpResponse = response as? HTTPURLResponse,
                        error == nil else {
                    print("Error fetching token: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP error! Status: \(httpResponse.statusCode), Body: \(body)")
                    completion(nil)
                    return
                }
                
                guard let responseData = try? JSONDecoder().decode(AuthTokenResponse.self, from: data!) else {
                    print("Error decoding JSON: \(body)")
                    completion(nil)
                    return
                }
                
                completion(responseData.access_token)
                
            }
        }.resume()
        
    }

}


