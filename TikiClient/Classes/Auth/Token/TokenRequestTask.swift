/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public class TokenRequestTask {

    private static let TAG = "TokenRequestTask"


    public static func execute(providerId: String, pubKey: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://account.mytiki.com/api/latest/auth/token") else {completion(nil); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let providerUrlSafe = providerId.toUrlSafe()
        let pubKeyUrlSafe = pubKey.toUrlSafe()
        let postData = "grant_type=client_credentials&client_id=provider:\(providerUrlSafe)&client_secret=\(pubKeyUrlSafe)&scope=account:provider trail publish&expires=600"
        
        request.httpBody = postData.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(self.handleResponse(data: data, response: response, error: error))
            }
        }
        task.resume()


    }

    private static func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> String? {
        guard let data = data, error == nil else {
            print("Error fetching token: \(error?.localizedDescription ?? "Unknown error")")
            return nil
        }

        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(TokenResponse.self, from: data)
                print(responseData.access_token)
                return responseData.access_token
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        } else {
            print("HTTP error! Status: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            print("HTTP error! Body: \(String(describing: String(data: data, encoding: .utf8)))")
            print("HTTP error! Status Code: \(String(describing: (response as? HTTPURLResponse)?.description))")
            
        }
        return nil
    }

    
}
