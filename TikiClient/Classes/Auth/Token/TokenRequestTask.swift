/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public class TokenRequestTask {

    private static let TAG = "TokenRequestTask"


    public static func execute(providerId: String, pubKey: String) {
        guard let url = URL(string: "https://account.mytiki.com/api/latest/auth/token") else {return}

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postData = "grant_type=client_credentials&client_id=provider:\(providerId.addingPercentEncoding(withAllowedCharacters: formURLEncodedAllowedCharacters)!.replacingOccurrences(of: " ", with:"+"))&client_secret=\(pubKey.addingPercentEncoding(withAllowedCharacters: formURLEncodedAllowedCharacters)!.replacingOccurrences(of: " ", with: "+"))&scope=account:provider%trail%publish&expires=600"
        
        request.httpBody = postData.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.handleResponse(data: data, response: response, error: error)
            }
        }

        task.resume()
    }

    private static func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard let data = data, error == nil else {
            print("Error fetching token: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(TokenResponse.self, from: data)
                print(responseData.access_token)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        } else {
            print("HTTP error! Status: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            print("HTTP error! Body: \(String(describing: String(data: data, encoding: .utf8)))")
            print("HTTP error! Status Code: \(String(describing: (response as? HTTPURLResponse)?.description))")
            
        }
    }

    private static let formURLEncodedAllowedCharacters: CharacterSet = {
        typealias c = UnicodeScalar
        
        // https://url.spec.whatwg.org/#urlencoded-serializing
        var allowed = CharacterSet()
        allowed.insert(c(0x2A))
        allowed.insert(charactersIn: c(0x2D)...c(0x2E))
        allowed.insert(charactersIn: c(0x30)...c(0x39))
        allowed.insert(charactersIn: c(0x41)...c(0x5A))
        allowed.insert(c(0x5F))
        allowed.insert(charactersIn: c(0x61)...c(0x7A))
        
        // and we'll deal with ` ` later…
        allowed.insert(" ")
        
        return allowed
    }()

}
