/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import XCTest
import TikiClient

final class TikiClientExampleTests: XCTestCase {

    func testGeneratePrivateKey() {
        let privateKey = KeyService.generate()
        XCTAssertNotNil(Data(SecKeyCopyExternalRepresentation(privateKey!, nil)! as Data).base64EncodedString())
    }
    
    func testGenerateAdressKeyTest() {
        let privateKey = KeyService.generate()
        XCTAssertNotNil(privateKey)
        let internalPubKey = SecKeyCopyPublicKey(privateKey!)
        XCTAssertNotNil(internalPubKey)
        let publicKeyData = SecKeyCopyExternalRepresentation(internalPubKey!, nil) as Data?
        XCTAssertNotNil(publicKeyData)
        let keySize = 256
        let exportImportManager = CryptoExportImportManager()
        let publicKeyB64 = exportImportManager.exportPublicKeyToPEM(publicKeyData!, keySize: keySize)!
        let publicKey = KeyService.address(b64PubKey: publicKeyB64)
        XCTAssertNotNil(publicKey!.base64EncodedString())
    }
    
    func testAddressStaticKey() {
        let staticPublicKeyB64 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAouIXxnNAZFEPzFHKaC4hRaU5wOZKRGhMOVPBG+ir/7lJl8i4II3aqVJEHNYZkZ+NQR8Yvea2F3Qsxjb+gY0Tm2OYlQB38dcVh3ArtfjraHZ3Jm1WpIM/FjB5RMYJwW3IiV/Xe/1xfxuu5ZW0PIRTOnz/Powyhu6I8tXyXG08gIKpJZyHmMrzSp81wnkm3qylk1DiP1sAyA9LIx6nGjy+LcAhjqcEdBpOOD4xF7HXJmQN9SDIYGf9E0yDtKL3au46FJ2ZJZKorLyiXzQ+wjPxc/EcCr5AR1UonwupjZHB37fDGlVND0pClpjPZOgx8BcaOAVqVqatGh9sNbNx7inTuwIDAQAB"
        let staticEncodeSha3Key = "VS7PKIfQKS5snZ-LLdKecTdVOf37GRwPBnK-87ipPhY"
        let publicKey = KeyService.address(b64PubKey: staticPublicKeyB64)
        XCTAssertEqual(publicKey!.base64EncodedString().base64UrlSafe(), staticEncodeSha3Key)
    }
    
    func testSignMessage() {
        let privateKey = KeyService.generate()
        XCTAssertNotNil(privateKey)
        let signMessage = KeyService.sign(message: "message", privateKey: privateKey!)
        XCTAssertNotNil(signMessage)
    }
    
    func testPermission() {
        
    }
}
