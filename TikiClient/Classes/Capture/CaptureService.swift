
/// Service for capturing and processing receipt data.
public class CaptureService {
    
    let publishUrl = "https://publish.mytiki.com"
    let captureScan = CaptureScan()

    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image or nil if the user canceled.
    public func scan(onImage: @escaping (UIImage?) -> Void){
        captureScan.start(onImage: onFinish)
    }

    ///
    /// Publishes the photos to Tiki.
    /// - Parameters:
    ///   - images: Array of photos to be published in base64 strings.
    ///   - token: the address token to authenticate the request to our server.
    /// - Returns: A Promise that resolves with the ID of the request or void in case of any error.
     */
    func publish(images: [UIImage], token: String, completion: @escaping (String?, Error?) -> Void) {
        let id = UUID().uuidString
        
        var request = URLRequest(url: URL(string: "\(publishuRL)/receipt/\(id)")!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.global(qos: .background).async {
            for image in images {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
                        if let error = error {
                            print("Error uploading files: \(error)")
                            completion(nil, error)
                            return
                        }
                        if let httpResponse = response as? HTTPURLResponse, !httpResponse.isSuccessStatusCode {
                            print("Error uploading files. Status: \(httpResponse.statusCode)")
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
}
