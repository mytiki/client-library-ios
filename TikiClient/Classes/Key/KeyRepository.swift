/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

final class KeyRepository {
    
    private let bundle: String = "com.mytiki.publish.client"
    
    func save(_ data: Data, service: String, key: String) {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundle + service,
            kSecAttrAccount: key,
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: bundle + service,
                kSecAttrAccount: key,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
    
    func read(service: String, key: String) -> Data? {
        
        let query = [
            kSecAttrService: bundle + service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func readAll(service: String) -> [String]? {
        var accounts: [String] = []
        
        let query: [String: Any] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrService as String: bundle + service, // change this line to match your service account value
          kSecReturnAttributes as String: true,
          kSecReturnData as String: true,
          kSecMatchLimit as String: kSecMatchLimitAll
        ]
                
        var result: CFTypeRef?
        let operationStatus = SecItemCopyMatching(query as CFDictionary, &result)
        
        let resultArray = result as? [NSDictionary]
        resultArray?.forEach { item in
            let accountData = item["acct"] as? String
            accounts.append(accountData ?? "")
            
        }
        return accounts
    
    }
        
    func delete(service: String, key: String) {
        
        let query = [
            kSecAttrService: bundle + service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }

    func update(_ data: Data, service: String, key: String) {

        // Item already exist, thus update it.
        let query = [
            kSecAttrService: bundle + service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let attributesToUpdate = [kSecValueData: data] as CFDictionary

        // Update existing item
        let error = SecItemUpdate(query, attributesToUpdate)
    }
    
}
