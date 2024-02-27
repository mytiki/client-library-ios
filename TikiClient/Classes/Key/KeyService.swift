class KeyService{

  public static let repository = KeyRepository()

  static public func generate() -> SecKey? {

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

    return privateKey
  }

  static public func address(publicKey: SecKey) -> Data? {
    guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
        return nil
    }

    return Data(publicKeyData.sha3(.sha256))
  }

  public static func sign(message: String, privateKey: SecKey) -> Data? {
      let data = message.data(using: .utf8) as! CFData

      var error: Unmanaged<CFError>?
      guard let signedData = SecKeyCreateSignature(privateKey, .rsaSignatureDigestPKCS1v15SHA256, data, &error) as Data? else {
        print("Error generating key pair: \(error.debugDescription)")
        return nil
      }
      return signedData
  }
    
}
