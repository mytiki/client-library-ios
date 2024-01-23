/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public class EmailRepository {
    
    public static func SaveEmailToken(authToken: AuthToken, email: String){
        let encoder = JSONEncoder()
        var jsonString = ""
        if let jsonData = try? encoder.encode(authToken){
            jsonString = String(data: jsonData, encoding: .utf8)!
        }
        let data = Data(jsonString.utf8)
        KeychainHelper.standard.save(data, service: ".email", key: email)
    }
    
    public static func ReadEmailToken(email: String) -> AuthToken {
        let data = KeychainHelper.standard.read(service: ".email", key: email)!
        let authToken = String(data: data, encoding: .utf8)!
        let decoder = JSONDecoder()
        let jsonData = authToken.data(using: .utf8)
        let auth = try! decoder.decode(AuthToken.self, from: jsonData!)
        return auth
    }
    
    public static func DeleteEmailToken(email: String){
        KeychainHelper.standard.delete(service: ".email", key: email)
    }
    
    public static func UpdateEmailToken(authToken: AuthToken, email: String){
        let encoder = JSONEncoder()
        var jsonString = ""
        if let jsonData = try? encoder.encode(authToken){
            jsonString = String(data: jsonData, encoding: .utf8)!
        }
        let data = Data(jsonString.utf8)
        KeychainHelper.standard.update(data, service: ".email", key: email)
    }
}
