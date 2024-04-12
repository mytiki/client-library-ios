import Security
import CryptoSwift

public class KeyService{

    public static let repository = KeyRepository()

    static public func generate() -> SecKey? {
      let attributes: [String: Any] = [
          kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
          kSecAttrKeySizeInBits as String: 2048,
          kSecPrivateKeyAttrs as String: [
              kSecAttrIsPermanent as String: true,
              kSecAttrApplicationTag as String: "com.mytiki.Keys",
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
    
    public static func publicKeyB64(privateKey: SecKey) -> String? {
        
        guard let publicKey = SecKeyCopyPublicKey(privateKey),
              let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) as Data? else {
                print("Error extracting Public Key Data")
                return nil
            }
        
        let keySize = 256
        let exportImportManager = CryptoExportImportManager()
        let publicKeyB64 = exportImportManager.exportPublicKeyToPEM(publicKeyData, keySize: keySize)!
        return publicKeyB64
    }

    public static func address(b64PubKey: String) -> String? {
      let decoded = Data(base64Encoded: b64PubKey)!
      let dataAddress = decoded.sha3(.sha256)
        return dataAddress.base64EncodedString().base64UrlSafe()
    }

    public static func sign(message: String, privateKey: SecKey) -> String? {
      let data = message.data(using: .utf8)! as CFData
      var error: Unmanaged<CFError>?
        guard let signedData = SecKeyCreateSignature (privateKey, .rsaSignatureMessagePKCS1v15SHA256, data, &error) as Data? else {
        print("Error generating key pair: \(error.debugDescription)")
        return nil
      }
      return signedData.base64EncodedString()
    }
    
    public static func get(providerId: String, userId: String, isPrivate: Bool = false) -> SecKey? {
        guard let data = repository.read(service: providerId, key: userId) else {
            return nil
        }
        return try? CriptoUtils.decodeSecKeyFromData(secKeyData: data, isPrivate: isPrivate)
    }
  
    public static func save(_ data: Data, service: String, key: String) {
        repository.save(data, service: service, key: key)
    }
    
}
