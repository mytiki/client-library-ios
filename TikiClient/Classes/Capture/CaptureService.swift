
/// Service for capturing and processing receipt data.
public class CaptureService {
    
    let publishUrl = "https://publish.mytiki.com"
    let captureScan = CaptureScan()
    
    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image or nil if the user canceled.
    public func scan(onImage: @escaping (UIImage?) -> Void){
        captureScan.start(onFinish: onImage)
    }

    ///
    /// Publishes the photos to Tiki.
    /// - Parameters:
    ///   - images: Array of photos to be published in base64 strings.
    ///   - token: the address token to authenticate the request to our server.
    /// - Returns: A Promise that resolves with the ID of the request or void in case of any error.
    public func publish(images: [UIImage], token: String, completion: @escaping (String?, Error?) -> Void) {
        let id = UUID().uuidString
        
        var request = URLRequest(url: URL(string: "\(publishUrl)/receipt/\(id)")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.global(qos: .background).async {
            for image in images {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
                        if error == nil {
                            let httpResponse = response as? HTTPURLResponse
                            completion(id, nil)
                            return
                        }
                        if let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode > 299) {
                            let uploadError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
                            completion(nil, uploadError)
                            return
                        }
                    }
                    task.resume()
                }
            }
            completion(id, nil)
        }
    }
    
    ///  Verify receipt uploaded
    /// - Parameters:
    /// - receiptId: Code of receipt
    /// - token:  Address token
    /// - completion:  Completion
    public func receipt(receiptId: String, token: String, completion: @escaping (_ success: String?, _ error: String?) -> Void) {

        var request = URLRequest(url: URL(string: "\(publishUrl)/receipt/\(receiptId)")!)
        
        request.httpMethod = "GET"
        request.addValue("Content-Type", forHTTPHeaderField: "application/json")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion("Upload Success", nil)
            } else {
                completion(nil, "HTTP error! Body: \(String(describing: String(data: data!, encoding: .utf8)))")
            }
        }.resume()
    }
}
