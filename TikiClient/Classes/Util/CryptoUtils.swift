import Security

public class CriptoUtils {
  static public func exportPublicKey(_ rawPublicKeyBytes: Data, base64EncodingOptions: Data.Base64EncodingOptions = []) -> String? {
    return rawPublicKeyBytes.base64EncodedString(options: base64EncodingOptions)
  }
    
  static public func exportKeyAsPEM(_ key: SecKey, isPrivateKey: Bool) -> String? {
    var cfError: Unmanaged<CFError>?
    let data = SecKeyCopyExternalRepresentation(key, &cfError)
    guard let keyData = data as Data?, cfError == nil else {
        return nil
    }
    
    let pemType = isPrivateKey ? "PRIVATE" : "PUBLIC"
    let keyHeader = "-----BEGIN RSA \(pemType) KEY-----\n"
    let keyFooter = "\n-----END RSA \(pemType) KEY-----"
    
    var base64EncodedString = keyData.base64EncodedString()
    base64EncodedString = base64EncodedString.enumerated().map { $0.offset % 64 == 0 ? "\n\($0.element)" : "\($0.element)" }.joined()
    
    return keyHeader + base64EncodedString + keyFooter
  }

  static public func decodeSecKeyFromData(secKeyData: Data, isPrivate: Bool = false) throws -> SecKey? {
    var keyClass = kSecAttrKeyClassPublic
    if isPrivate {
        keyClass = kSecAttrKeyClassPrivate
    }
    let attributes: [String:Any] = [
        kSecAttrKeyClass as String: keyClass,
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits as String: 2048 as AnyObject,
    ]

    var error: Unmanaged<CFError>? = nil
      
    guard let secKey = SecKeyCreateWithData(secKeyData as CFData, attributes as CFDictionary, &error) else {
        return nil
    }

    return secKey
  }
}
