/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public class EmailRepository {
    
    public static func SaveEmailToken(authToken: AuthToken, email: String){
//        let encoder = JSONEncoder()
//        var jsonString = ""
//        if let jsonData = try? encoder.encode(authToken){
//            jsonString = String(data: jsonData, encoding: .utf8)!
//        }
//        let data = Data(jsonString.utf8)
//        KeychainHelper.save(data, service: ".email", key: email)
    }
    
    public static func ReadEmailToken(email: String) -> AuthToken {
//         -> AuthToken
//        let data = KeychainHelper.read(service: ".email", key: email)!
//        let authToken = String(data: data, encoding: .utf8)!
//        let decoder = JSONDecoder()
//        let jsonData = authToken.data(using: .utf8)
//        let auth = try! decoder.decode(AuthToken.self, from: jsonData!)
        return AuthToken.init(auth: "", refresh: "", provider: "", expiration: nil)
    }
    public static func ReadAllEmail() -> [AuthEmailTokenResponse]{
//        -> [AuthTokenResponse]
//        let accounts = KeychainHelper.readAll(service: ".email")
//        var authTokenResponse: [AuthTokenResponse] = []
//        for account in accounts! {
//            var acc = ReadEmailToken(email: account)
//            authTokenResponse.append(AuthTokenResponse(auth: acc.auth, refresh: acc.refresh, provider: acc.provider, email: account, expiration: acc.expiration))
//        }
        return [AuthEmailTokenResponse(auth: "", refresh: "", provider: "", email: "", expiration: nil)]
    }
    
    public static func DeleteEmailToken(email: String){
//        KeychainHelper.delete(service: ".email", key: email)
    }
    
    public static func UpdateEmailToken(authToken: AuthToken, email: String){
//        let encoder = JSONEncoder()
//        var jsonString = ""
//        if let jsonData = try? encoder.encode(authToken){
//            jsonString = String(data: jsonData, encoding: .utf8)!
//        }
//        let data = Data(jsonString.utf8)
//        KeychainHelper.update(data, service: ".email", key: email)
    }
}
