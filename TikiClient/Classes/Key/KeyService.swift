import Security
import CryptoSwift

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

  static public func address(b64PubKey: String) -> Data? {
//      guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, .rsaEncryptionPKCS1) //3
//      else {
//          print("not supported cryptography")
//          return nil
//      }
      
//       guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
//         return nil
//       }
//      let pubkey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAww3yIL1Pd55Zs/HryGYBTs+datUzY1LBwHESILtd7wqZJrOBpKGrQLkGULSHjJ4fbIQg9EO5KQCz0KYG+7VpWejH7GoQ/KGakri50Lz+utvyseu0wQN+LV0Z52oWml2HnGf7z2yy2D0EsxI7VTHKuzqsW4ubqgLJRbRKHuvu6d2ZXOnQtVH22uNDhYOdwOBlyiOapsQluyNnnTUnGdP3OQ0KbUhvig2Yt7LLnRwNQQscAbn7wOtiJvzS1MNNfdVwxAtEIIYG6b0jc2p2elOoBHQQNeVpVfQ2LdjprCF+DQ1jBNd8Fo3f9Mnng8ce4EKCDJBf/3I1zwV2otaATisvBwIDAQAB"
      
      
      let decoded = Data(base64Encoded: b64PubKey)!
    
      var dataAddress = decoded.sha3(.sha256)
      let address = dataAddress.base64EncodedString().base64UrlEncoding()
      return dataAddress
      
      
//     return publicKeyData.sha3(.sha256)
  }

  public static func sign(message: String, privateKey: SecKey) -> Data? {
      let data = message.data(using: .utf8)! as CFData
      
      guard let cfdata = SecKeyCopyExternalRepresentation(privateKey, nil) else {print("error"); return nil}

      guard let rsaKey = try? RSA(rawRepresentation: cfdata as Data) else {return nil}
      
      guard let signedData = try? rsaKey.sign(message.bytes) else {return nil}
      
//      var error: Unmanaged<CFError>?
//      guard let signedData = SecKeyCreateSignature(privateKey, .rsaSignatureDigestPKCS1v15SHA256, data, &error) as Data? else {
//        print("Error generating key pair: \(error.debugDescription)")
//        return nil
//      }
      
      return Data(signedData)
  }
    
}
