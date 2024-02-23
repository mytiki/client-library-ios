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
        // ...

        // Simulate token retrieval completion with a result
        let result: String? = "Simulated Provider Token"
        completion(result)
    }
    
    static func signMessage(message: String, privateKey: String, completion: @escaping (String?) -> Void) {
        // Implement logic to sign the message using private key
        // ...

        // Simulate signature generation completion with a result
        let result: String? = "SimulatedSignature"
        completion(result)
    }
    
    static func registerAddress(providerId: String, userId: String, completion: @escaping (Bool) -> Void) {
        getToken(providerId: providerId) {
            accessToken in
            guard let accessToken = accessToken else {
                print("Error getting token")
                completion(false)
                return
            }
            generateKeyPair()
            
            
            
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
    public static func generateKeyPair() -> (publicKey: SecKey, privateKey: SecKey)? {
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
            return nil
        }
        
        publicKey = SecKeyCopyPublicKey(privateKey)
        
        return (publicKey!, privateKey)
    }
    
    static func generateKey(completion: @escaping (CryptoKeyPair?) -> Void) {
        // Implement logic to generate and return a key pair
        // ...

        // Simulate key pair generation completion with a result
        var keyPair = generateKeyPair()
        let result: CryptoKeyPair? = CryptoKeyPair(publicKey: "", privateKey: "SimulatedPrivateKey")
        completion(result)
    }

    // Method to create the address using SHA-256 digest
    public static func address(publicKey: SecKey) -> String? {
        do {
            // Get the public key data
            guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
                return nil
            }

            print(publicKeyData.base64EncodedString())
            
            // Create SHA-256 digest of the public key
            let digest = publicKeyData.sha3(.sha256)
            print(digest)

            return Data(digest).base64EncodedString()
        }
    }
}
