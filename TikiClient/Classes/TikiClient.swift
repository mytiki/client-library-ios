
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
    public static func initialize(userId: String, completion: @escaping (String?) -> Void) {
        if(config == nil){
            fatalError("Config is nil")
        }

        let key = KeyService.get(providerId: TikiClient.config!.providerId, userId: userId, isPrivate: true)
            
        if(key == nil){
            auth.registerAddress(userId: userId, providerId: TikiClient.config!.providerId, pubKey: TikiClient.config!.publicKey, completion: {address, error  in
                guard address != nil else {
                    completion("Register Adress Error")
                    return
                }
            })
        }
        TikiClient.userId = userId
    }
    
    public static func configuration(config: Config){
        TikiClient.config = config
    }
    
    public static func createLicense(completion: @escaping (String?) -> Void){
        if(TikiClient.config == nil){
            completion("Config is nil")
        }
        if(TikiClient.userId == nil){
            completion("UserId is nil")
        }
        
        guard let privateKey = KeyService.get(providerId: TikiClient.config!.providerId, userId: TikiClient.userId!, isPrivate: true) else {
                completion("Private Key not found. Use the TikiClient.initialize method to register the user.")
                return
            }
        
        guard let publicKeyB64 = KeyService.publicKeyB64(privateKey: privateKey) else{
            completion("Error extracting public key")
            return
        }
                                                            
        guard let address = KeyService.address(b64PubKey: publicKeyB64) else{
            completion("Error decoding address")
            return
        }

        
        guard let signature = KeyService.sign(message: address, privateKey: privateKey) else{
            completion("Error sign request")
            return
        }
        
        TikiClient.auth.token(providerId: TikiClient.config!.providerId, secret: signature, scopes: ["trail", "publish"], address: address, completion: { addressToken, error in
            if(addressToken == nil){
               completion("It was not possible to get the token, try to inialize!")
               return
            }
            let terms = TikiClient.terms(completion: completion)

            let bundleId = Bundle.main.bundleIdentifier

            var licenseReq = LicenseRequest(
                ptr: userId!,
                tags: ["purchase_history"],
                uses: [Use(
                    usecases: [Usecase(usecase: .attribution)],
                   destinations: ["*"])],
                terms: terms, 
                description: "TIKI Client License",
                origin: bundleId!,
                signature: signature)

            let encoder = JSONEncoder()
            let licenseReqStr: String = try! String(data: encoder.encode(licenseReq), encoding: .utf8)!

            guard let licenseSignature = KeyService.sign(message: licenseReqStr, privateKey: privateKey) else{
                completion("error generating signature")
                return
            }
            licenseReq.signature = licenseSignature
            TikiClient.license.create(token: addressToken!, postLicenseRequest: licenseReq, completion: completion)
        })
    }
    
    public static func terms(completion: @escaping (String?) -> Void) -> String {
        let bundle = Bundle(for: TikiClient.self)
        guard let path = bundle.path(forResource: "Assets/terms", ofType: "md") else {
            completion("terms.md not found")
            return ""
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
        
        return terms ?? ""
    }
}
