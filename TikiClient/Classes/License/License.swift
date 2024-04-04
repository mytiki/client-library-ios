import Foundation

/// Service for managing user licenses.
public class License {
    
    public init() {}
    
    private var baseUrl: String = "https://trail.mytiki.com"

    /**
     Creates a license to publish data to Tiki.

     - Parameters:
        - token: The address token.
        - postLicenseRequest: An object containing the main information of the license.
     
     - Returns: The saved license object.
     */
    public func create(token: String, postLicenseRequest: PostLicenseRequest) -> PostLicenseRequest {
        let url = "\(baseUrl)/license/create"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"

        
        guard let jsonData = try? JSONEncoder().encode(postLicenseRequest) else {
            print("Error encoding JSON")
            return postLicenseRequest
        }
        
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("########License create successful")
                
            } else {
                print("Error registering license. HTTP status: \(response?.description ?? "Unknown")")
                print("HTTP error! Body: \(String(describing: String(data: data!, encoding: .utf8)))")

            }
        }.resume()
        return postLicenseRequest
    }


    
}
