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
    
    typealias TokenRequestCallback = (String?) -> Void

    public struct CryptoKeyPair {
        let publicKey: String
        let privateKey: String
    }
    
    static func getToken(providerId: String, completion: @escaping TokenRequestCallback) {
        // Implement logic to fetch and return the provider token

        // Simulate token retrieval completion with a result
        let result: String? = "Simulated Provider Token"
        completion(result)
    }
    
    static func signMessage(message: String, privateKey: SecKey, completion: @escaping (String?) -> Void) {
        let data = message.data(using: .utf8)!

        var error: Unmanaged<CFError>?
        guard let signedData = SecKeyCreateSignature(privateKey,
                                                     .rsaSignatureDigestPKCS1v15SHA256,
                                                     data as CFData,
                                                     &error) as Data? else
        {
            completion(nil)
            return
        }

        // Simulate signature generation completion with a result
        let result: String? = signedData.base64EncodedString()
        completion(result)
    }
    
    public static func registerAddress(providerId: String, userId: String, pubKey: String, completion: @escaping (Bool) -> Void) {
        TokenRequestTask.execute(providerId: providerId, pubKey: pubKey){ accessToken in
            guard let accessToken = accessToken else {
                print("Error getting token")
                completion(false)
                return
            }
            generateKeyPair() { keyPair in
                guard let keyPair = keyPair else {
                    print("Error generating key pair")
                    completion(false)
                    return
                }
                address(publicKey: keyPair.publicKey){ address in
                    guard let address = address else {
                        print("Error generating address")
                        completion(false)
                        return
                    }
                    signMessage(message: "\(userId).\(address)", privateKey: keyPair.privateKey) { signature in
                        guard let signature = signature else {
                            print("Error generating signature")
                            completion(false)
                            return
                        }
                        
                        let urlString = "https://account.mytiki.com/api/latest/provider/\(providerId)/user"
                        guard let url = URL(string: urlString) else {
                            print("Invalid URL")
                            completion(false)
                            return
                        }
                        
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        
                        let encoder = JSONEncoder()
                        var jsonString = ""
                        guard let publicKeyData = SecKeyCopyExternalRepresentation(keyPair.publicKey, nil) as Data? else {
                            completion(false)
                            return
                        }
                        let body = UserAddressRequest(id: userId, address: address.toUrlSafe(), pubKey: publicKeyData.base64EncodedString(), signature: signature)
                        if let jsonData = try? encoder.encode(body){
                            jsonString = String(data: jsonData, encoding: .utf8)!
                        }
                        let data = Data(jsonString.utf8)
                        request.httpBody = data
                        
                        request.addValue("application/json", forHTTPHeaderField: "accept")
                        request.addValue("application/json", forHTTPHeaderField: "content-type")
                        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
                        
                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                                print("########User registration successful")
                                completion(true)
                            } else {
                                print("Error registering user. HTTP status: \(response?.description ?? "Unknown")")
                                print("HTTP error! Body: \(String(describing: String(data: data!, encoding: .utf8)))")
                                completion(false)
                            }
                        }
                        
                        task.resume()

                    }
                }
            }
        }
    }

    /// Authenticates with TIKI and saves the auth and refresh tokens.
    ///
    /// - Parameters:
    ///   - publishingId: The TIKI Publishing ID.
    ///   - userId: The user identification.
    /// - Returns: The authentication token.
    public func authenticate(publishingId: String, userId: String) -> String {
        return ""
    }

    public static func saveAuthToken(token: String, service: String){
        //TODO
    }
    /// Retrieves the authentication token, refreshing if necessary.
    ///
    /// - Returns: The authentication token.
    public func token() -> String {
        return ""
    }

    /// Revokes the authentication token.
    public func revoke() {
        // Implementation
    }

    /// Refreshes the authentication token.
    ///
    /// - Returns: The updated authentication token.
    public func refresh() -> String {
        return ""
    }
    
 
    // Method to generate a key pair
    public static func generateKeyPair(completion: @escaping ((publicKey: SecKey, privateKey: SecKey)?) -> Void) {
        var publicKey, privateKey: SecKey?
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: "com.example.TikiKeyAlias",
                kSecAttrAccessControl as String: SecAccessControlCreateWithFlags(
                    nil,
                    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                    [],
                    nil
                )!
            ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print("Error generating key pair: \(error.debugDescription)")
            completion(nil)
            return
        }
        
        publicKey = SecKeyCopyPublicKey(privateKey)
        
        
        completion((publicKey!, privateKey))
    }


    // Method to create the address using SHA-256 digest
    public static func address(publicKey: SecKey, completion: @escaping (String?) -> Void) {
        do {
            // Get the public key data
            guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
                completion(nil)
                return
            }
            // Create SHA-256 digest of the public key
            let digest = publicKeyData.sha3(.sha256)
            completion(Data(digest).base64EncodedString())
        }
    }
    
    private static let formURLEncodedAllowedCharacters: CharacterSet = {
        typealias c = UnicodeScalar
        
        // https://url.spec.whatwg.org/#urlencoded-serializing
        var allowed = CharacterSet()
        allowed.insert(c(0x2A))
        allowed.insert(charactersIn: c(0x2D)...c(0x2E))
        allowed.insert(charactersIn: c(0x30)...c(0x39))
        allowed.insert(charactersIn: c(0x41)...c(0x5A))
        allowed.insert(c(0x5F))
        allowed.insert(charactersIn: c(0x61)...c(0x7A))
        
        // and we'll deal with ` ` later…
        allowed.insert(" ")
        
        return allowed
    }()
}

