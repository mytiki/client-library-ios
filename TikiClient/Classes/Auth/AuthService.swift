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
    
    public init(){}
    
    public func address(providerId: String, userId: String, pubKey: String, completion: @escaping (String?) -> Void){
        let urlString = URL(string: "https://account.mytiki.com/api/latest/provider/\(providerId)/user")
        
        token(providerId: providerId, clientSecret: pubKey){ token in
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

            guard let internalPubKey = SecKeyCopyPublicKey(privateKey),
                let publicKeyData = SecKeyCopyExternalRepresentation(internalPubKey, nil) as Data? else {
                    print("Error extracting Public Key Data")
                    completion(nil)
                    return
                  }
            
            let keyType = kSecAttrKeyTypeRSA
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
            
        }
    }
        
    public func token(providerId: String, clientSecret: String, completion: @escaping (String?) -> Void){
        var request = URLRequest(url: URL(string: "https://account.mytiki.com/api/latest/auth/token")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postData = "grant_type=client_credentials&client_id=provider:\(providerId.urlEncoded())&client_secret=\(clientSecret.urlEncoded())&scope=account:provider trail publish&expires=600"
        
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
    public func exportPublicKey(_ rawPublicKeyBytes: Data, base64EncodingOptions: Data.Base64EncodingOptions = []) -> String?
    {
        return rawPublicKeyBytes.base64EncodedString(options: base64EncodingOptions)
    }
    
    func exportKeyAsPEM(_ key: SecKey, isPrivateKey: Bool) -> String? {
        var cfError: Unmanaged<CFError>?
        let data = SecKeyCopyExternalRepresentation(key, &cfError)
        guard let keyData = data as Data?, cfError == nil else {
            print("Error exporting key: \(cfError.debugDescription)")
            return nil
        }
        
        let pemType = isPrivateKey ? "PRIVATE" : "PUBLIC"
        let keyHeader = "-----BEGIN RSA \(pemType) KEY-----\n"
        let keyFooter = "\n-----END RSA \(pemType) KEY-----"
        
        var base64EncodedString = keyData.base64EncodedString()
        // Wrap lines at 64 characters as per PEM format
        base64EncodedString = base64EncodedString.enumerated().map { $0.offset % 64 == 0 ? "\n\($0.element)" : "\($0.element)" }.joined()
        
        return keyHeader + base64EncodedString + keyFooter
    }

}


