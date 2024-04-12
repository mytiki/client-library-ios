
import Foundation
import SwiftUI

/// Tiki Client Library
///
/// The TIKI APIs comprise a set of HTTP REST APIs designed for seamless integration with any
/// standard HTTP client. The Client Libraries serve as a user-friendly layer around the TIKI APIs,
/// introducing methods for common operations such as authorization, licensing, capture, card-linked
/// offers, and rewards. It is a collection of pre-existing code with minimal dependencies, offering
/// a streamlined integration process with TIKI Rest APIs, which reduces the amount of code necessary
/// for integration.
///
/// `TikiClient` is the top-level entry point for the TIKI Client Library. It offers simple methods
/// that call the underlying libraries to perform common operations. Programmers can use it to
/// simplify the integration process or opt for individual libraries based on their specific needs.
public class TikiClient {
    
    public static let auth = AuthService()
    public static let capture = CaptureService()
    public static let license = License()
    public static var config: Config? = nil
    public static var userId: String? = nil

    /// Initializes the `TikiClient` with the application context and sets its parameters.
    /// - Parameters:
    ///   - context: The application context.
    ///   - providerId: The TIKI Publishing ID of the data provider.
    ///   - userId: The user identification from the provider.
    ///   - company: The legal information of the company.
    public static func initialize(userId: String) {
        if(config == nil){
            fatalError("Config is nil")
        }

        let key = KeyService.get(providerId: TikiClient.config!.providerId, userId: userId, isPrivate: true)
            
        if(key == nil){
            auth.registerAddress(userId: userId, providerId: TikiClient.config!.providerId, pubKey: TikiClient.config!.publicKey, completion: {address in
                guard let userAddress = address else {
                    fatalError("Error user address register")
                }
                print("Address Register: \(address)")
            })
        }
        TikiClient.userId = userId
    }
    
    public static func configuration(config: Config){
        TikiClient.config = config
    }
    
    public static func createLicense(){
        if(TikiClient.config == nil){
            fatalError("Config is nil")
        }
        if(TikiClient.userId == nil){
            fatalError("UserId is nil")
        }
        
        guard let key = KeyService.get(providerId: TikiClient.config!.providerId, userId: TikiClient.userId!, isPrivate: true) else {
                print("Key Pair not found. Use the TikiClient.initialize method to register the user.")
                return
            }
        
        var error:Unmanaged<CFError>?
        var dataKeybB64 = String()
        if let cfdata = SecKeyCopyExternalRepresentation(key, &error) {
           let data:Data = cfdata as Data
           let b64Key = data.base64EncodedString()
            dataKeybB64 = b64Key
        }
                                                            
        guard let address = KeyService.address(b64PubKey: dataKeybB64) else{
            print("error decoding address")
            return
        }
        print("address")
        print(address)
        
        guard let signature = KeyService.sign(message: address, privateKey: key as SecKey) else{
            print("error signing request")
            return
        }
        
        TikiClient.auth.token(providerId: TikiClient.config!.providerId, secret: signature, scopes: ["trail", "publish"], completion: { addressToken in print(addressToken ?? "")
            if(addressToken == nil){
               print("It was not possible to get the token, try to inialize!")
               return
            }
            let terms = TikiClient.terms()

            let bundleId = Bundle.main.bundleIdentifier

            var licenseReq = LicenseRequest(ptr: userId!, tags: ["purchase_history"], uses: [Use(usecases: [Usecase(usecase: .attribution)], destinations: ["*"])], terms: terms, description: "", origin: bundleId!, expiry: "undefined", signature: "")

            let encoder = JSONEncoder()
            let licenseReqStr: String = try! String(data: encoder.encode(licenseReq), encoding: .utf8)!

            let licenseSignature = KeyService.sign(message: licenseReqStr, privateKey: key as! SecKey)
            licenseReq.signature = licenseSignature
            let license = TikiClient.license.create(token: addressToken!, postLicenseRequest: licenseReq)
            print(license)
        })
    }
    
    public static func terms() -> String {
        guard let path = Bundle(identifier: "org.cocoapods.TikiClient")!.path(forResource: "terms", ofType: "md") else {
            fatalError("terms.md not found")
        }
        if(TikiClient.config == nil){
            fatalError("Config is nil")
        }
        var terms = try? String(contentsOfFile: path)

        let replacements = [
            "{{{COMPANY}}}": TikiClient.config!.companyName,
            "{{{JURISDICTION}}}": TikiClient.config!.companyJurisdiction,
            "{{{TOS}}}": TikiClient.config!.tosUrl,
            "{{{POLICY}}}": TikiClient.config!.privacyUrl
        ]

        for (key, value) in replacements {
            terms = terms?.replacingOccurrences(of: key, with: value)
        }

        print(terms)
        return terms ?? ""
    }
}
