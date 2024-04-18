/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation

public final class KeyRepository {
    
    private let bundle: String = "com.mytiki.publish.client"
    
    func save(_ data: Data, service: String, key: String) {
        
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundle + service,
            kSecAttrAccount: key,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: bundle + service,
                kSecAttrAccount: key,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            SecItemUpdate(query, attributesToUpdate)
        }
        
        if status != errSecSuccess {
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
        
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &extractedData)

        guard status == errSecItemNotFound || status == errSecSuccess else {
          fatalError("Unable to retrieve the secret")
        }

        guard status != errSecItemNotFound else {
          return nil
        }
        return extractedData as? Data
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
        SecItemCopyMatching(query as CFDictionary, &result)
        
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
        
        SecItemDelete(query)
    }

    func update(_ data: Data, service: String, key: String) {

        let query = [
            kSecAttrService: bundle + service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let attributesToUpdate = [kSecValueData: data] as CFDictionary

        SecItemUpdate(query, attributesToUpdate)
    }
    
}
