//
//  UrlSafe.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 26/02/24.
//

import Foundation

extension String {
    
    public func toUrlSafe() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: String.formURLEncodedAllowedCharacters)!.replacingOccurrences(of: " ", with:"+")
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
