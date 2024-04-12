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

    public func registerAddress(userId: String, providerId: String, pubKey: String, completion: @escaping (String?) -> Void) {
        let urlString = URL(string: "https://account.mytiki.com/api/latest/provider/\(providerId)/user")
        
        token(providerId: providerId, secret: pubKey, scopes: ["account:provider"], address: nil, completion: { token in
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

            guard let publicKey = SecKeyCopyPublicKey(privateKey),
                let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
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

            let message = "\(userId).\(address.base64EncodedString().base64UrlSafe())"
            
            guard let signature = KeyService.sign(message: message, privateKey: privateKey) else {
                print("Error generating signature")
                completion(nil)
                return
            }
            
            let reqBody = AuthAddrRequest(id: userId, address: address.base64EncodedString().base64UrlSafe(), pubKey: publicKeyB64.base64UrlSafe(), signature: signature.base64EncodedString())
            
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
        
    public func token(providerId: String, secret: String, scopes: [String], address: String? = nil,  completion: @escaping (String?) -> Void){
//        let headers = [
//          "User-Agent": "Thunder Client (https://www.thunderclient.com/)",
//          "Accept": "application/json",
//          "Content-Type": "application/x-www-form-urlencoded"
//        ]
//
//        let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
//        postData.append("&client_id=provider:8204cd6f-5b6c-4ddb-be14-dd5605c6a745".data(using: String.Encoding.utf8)!)
//        postData.append("&client_secret=MIIBCgKCAQEAtk9JrSBKdppHhXx+pU7JTd7dGpv+Q6idZIUW6Aot7sYFYu+n4tr7YfKNpNHdor/Yujqfg9wPU2MOWTPiXbgH9nwnQLBM7o8szijIVY7J1GjlmGosEF0uk9/FZiE/FZY+R0+MqKd2kKEkeNddV94Jf8U683yZofFjfqEdW16cWUP5aAT1NBmemeTcbzZGlDGk3OebuPFPKnBulZrDCdkDdmGMJfmZvSp7XTbu91xV2Ff0VnxWlOMFi2AQVZ0F15QliXYnkA7zYWBBCP+lsE0V5tPqtL5jMg/fJI411Ez9x0rycoAXY7dfjKloZVw3mJdu1KAbkJDmk7TlymIvqeVL4QIDAQAB".data(using: String.Encoding.utf8)!)
//        postData.append("&scope=account:provider".data(using: String.Encoding.utf8)!)
//
//        let request = NSMutableURLRequest(url: NSURL(string: "https://account.mytiki.com/api/latest/auth/token")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = headers
//        request.httpBody = postData as Data
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//          if (error != nil) {
//            print(error)
//          } else {
//            let httpResponse = response as? HTTPURLResponse
//              print(String(data: data!, encoding: .utf8))
//          }
//        })
//
//        dataTask.resume()
        var request = URLRequest(url: URL(string: "https://account.mytiki.com/api/latest/auth/token")!)
//        var request = URLRequest(url: URL(string: "https://postman-echo.com/post")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if(address != nil){
            
        }

        let provider = address == nil ? "provider:\(providerId)" : "addr:\(providerId):\(address!.base64UrlSafe())"
        let scopesJoined = scopes.joined(separator: " ")
        let slashedSecret = secret.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let postData = "grant_type=client_credentials&client_id=\(provider)&client_secret=\(addSlashedSecret)&scope=\(scopesJoined)&expires=600"
        
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


