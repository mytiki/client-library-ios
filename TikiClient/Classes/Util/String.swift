extension String {
    
    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: String.formURLEncodedAllowedCharacters)!.replacingOccurrences(of: " ", with:"+")
    }
    public func base64UrlSafe() -> String {
        return self
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: " ", with: "")
        
    }
    
    
    public func base64Decoded() -> String? {
        var st = self
            .replacingOccurrences(of: "_", with: "/")
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "-", with: "+")
        let remainder = self.count % 4
        if remainder > 0 {
            st = self.padding(toLength: self.count + 4 - remainder,
                              withPad: "=",
                              startingAt: 0)
        }
        guard let d = Data(base64Encoded: st, options: .ignoreUnknownCharacters) else{
            return nil
        }
        return String(data: d, encoding: .utf8)
    }
    public func removePadding() -> String? {
        return self.replacingOccurrences(of: "=", with: "")
        
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

extension Data {
    
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        var i = hexString.startIndex
        for _ in 0..<len {
            let j = hexString.index(i, offsetBy: 2)
            let bytes = hexString[i..<j]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
            i = j
        }
        self = data
    }
}
