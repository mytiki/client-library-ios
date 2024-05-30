
import Foundation
import SwiftUI
import AppAuth

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
    public static let email = EmailService()
    public static let license = License()
    public static let tracking = Tracking()
    public static let location =  LocationDataManager()
    public static var config: Config? = nil
    public static var userId: String? = nil
    public static var offer: Offer?
    private static var authState: OIDAuthState?
    private static let emailService = EmailService()


    /// Initializes the `TikiClient` with the application context and sets its parameters.
    /// - Parameters:
    ///   - context: The application context.
    ///   - providerId: The TIKI Publishing ID of the data provider.
    ///   - userId: The user identification from the provider.
    ///   - company: The legal information of the company.
    public static func initialize(userId: String, completion: @escaping (String?) -> Void) {
        if(config == nil){
            completion("Config is nil")
            return
        }

        let key = KeyService.get(providerId: TikiClient.config!.providerId, userId: userId, isPrivate: true)
        
        let authorizationEndpoint = URL(string: "https://accounts.google.com/o/oauth2/v2/auth")!
        let tokenEdpoint = URL(string: "https://www.googleapis.com/oauth2/v4/token")!
        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint,
                                                    tokenEndpoint: tokenEdpoint)
            
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
    
    /// Sets the configuration of the TikiClient
    /// - Parameters:
    ///   - config: The configuration object with all the needed information to configurate
    public static func configuration(config: Config){
        TikiClient.config = config
    }
    
    /// Creates a license to publish data to Tiki.
    public static func createLicense(completion: @escaping (String?) -> Void, onError: @escaping (String?) -> Void){
        if(TikiClient.config == nil){
            onError("Config is nil")
        }
        if(TikiClient.userId == nil){
            onError("UserId is nil")
        }
        
//        for permission in permissions {
//            if(!permission.isAuthorized()){
//                completion("\(permission.name()) has no permission, please, ask this permission first")
//                return
//            }
//        }
        
        guard let privateKey = KeyService.get(providerId: TikiClient.config!.providerId, userId: TikiClient.userId!, isPrivate: true) else {
                onError("Private Key not found. Use the TikiClient.initialize method to register the user.")
                return
            }
        
        guard let publicKeyB64 = KeyService.publicKeyB64(privateKey: privateKey) else{
            onError("Error extracting public key")
            return
        }
                                                            
        guard let address = KeyService.address(b64PubKey: publicKeyB64) else{
            onError("Error decoding address")
            return
        }

        
        guard let signature = KeyService.sign(message: address, privateKey: privateKey) else{
            onError("Error sign request")
            return
        }
        
        TikiClient.auth.token(providerId: TikiClient.config!.providerId, secret: signature, scopes: ["trail", "publish"], address: address, completion: { addressToken, error in
            if(addressToken == nil){
               onError("It was not possible to get the token, try to inialize!")
               return
            }
            let terms = TikiClient.terms(completion: completion, onError: onError)

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
                onError("error generating signature")
                return
            }
            licenseReq.signature = licenseSignature
            TikiClient.license.create(token: addressToken!, postLicenseRequest: licenseReq, completion: completion)
        })
    }
    
    /// Gets the terms of use
    public static func terms(completion: @escaping (String?) -> Void, onError: @escaping (String?) -> Void) -> String {
        let bundle = Bundle(for: TikiClient.self)
        guard let path = bundle.path(forResource: "Assets/terms", ofType: "md") else {
            onError("terms.md not found")
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
    
    public static func loginEmail(clientID: String, completion: @escaping () -> Void){
        TikiClient.emailService.login (.google, clientID){
            completion()
        }
    }
    public static func verifyEmail(email: String) -> AuthToken{
        let authToken = TikiClient.emailService.account(email: email)
        return authToken
    }
    
    public static func createOffer(_id: String?, ptr: String?, description: String?, terms: String?, reward: [Reward], use: Use, tags: [Tag], permissions: [Permission?]){
        self.offer = Offer(_id: _id, ptr: ptr, description: description, terms: terms, reward: reward, use: use, tags: tags, permissions: permissions, mutable: true)
    }
    public static func acceptOffer(completion: @escaping (String?) -> Void, onError: @escaping (String) -> Void){
        if(offer == nil){
            onError("Offer is nil")
            return
        }
        if(TikiClient.config == nil){
            onError("Config is nil")
        }
        if(TikiClient.userId == nil){
            onError("UserId is nil")
        }
        var tags: [String] = []
        for tag in offer!.tags {
            tags.append(tag.value)
        }
        
        guard let privateKey = KeyService.get(providerId: TikiClient.config!.providerId, userId: TikiClient.userId!, isPrivate: true) else {
                onError("Private Key not found. Use the TikiClient.initialize method to register the user.")
                return
            }
        
        guard let publicKeyB64 = KeyService.publicKeyB64(privateKey: privateKey) else{
            onError("Error extracting public key")
            return
        }
                                                            
        guard let address = KeyService.address(b64PubKey: publicKeyB64) else{
            onError("Error decoding address")
            return
        }

        
        guard let signature = KeyService.sign(message: address, privateKey: privateKey) else{
            onError("Error sign request")
            return
        }
        TikiClient.auth.token(providerId: TikiClient.config!.providerId, secret: signature, scopes: ["trail", "publish"], address: address, completion: { addressToken, error in
            if(addressToken == nil){
                onError("It was not possible to get the token, try to inialize!")
                return
            }
            let licenseRequest = LicenseRequest(ptr: offer!.ptr!, tags: tags, uses: [offer!.use], terms: offer!.terms!, description: offer!.description!, origin: Bundle.main.bundleIdentifier!, signature: signature)
            TikiClient.license.create(token: addressToken!, postLicenseRequest: licenseRequest, completion: completion)
        })
    }
    
    
    public static func denyOffer(offer: Offer, completion: @escaping (String?) -> Void, onError: @escaping (String) -> Void){
        if(offer == nil){
            onError("Offer is nil")
            return
        }
        if(TikiClient.config == nil){
            onError("Config is nil")
        }
        if(TikiClient.userId == nil){
            onError("UserId is nil")
        }
        var tags: [String] = []
        for tag in offer.tags {
            tags.append(tag.value)
        }
        
        guard let privateKey = KeyService.get(providerId: TikiClient.config!.providerId, userId: TikiClient.userId!, isPrivate: true) else {
                onError("Private Key not found. Use the TikiClient.initialize method to register the user.")
                return
            }
        
        guard let publicKeyB64 = KeyService.publicKeyB64(privateKey: privateKey) else{
            onError("Error extracting public key")
            return
        }
                                                            
        guard let address = KeyService.address(b64PubKey: publicKeyB64) else{
            onError("Error decoding address")
            return
        }

        
        guard let signature = KeyService.sign(message: address, privateKey: privateKey) else{
            onError("Error sign request")
            return
        }
        
        TikiClient.auth.token(providerId: TikiClient.config!.providerId, secret: signature, scopes: ["trail", "publish"], address: address, completion: { addressToken, error in
            if(addressToken == nil){
                onError("It was not possible to get the token, try to inialize!")
                return
            }
            let licenseRequest = LicenseRequest(ptr: offer.ptr!, tags: tags, uses: [], terms: offer.terms!, description: offer.description!, origin: Bundle.main.bundleIdentifier!, signature: signature)
            TikiClient.license.create(token: addressToken!, postLicenseRequest: licenseRequest, completion: completion)
            
        })

    }

}
