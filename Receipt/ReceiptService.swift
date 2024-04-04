/*
 *
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation
import MobileCoreServices
import UniformTypeIdentifiers
public class ReceiptService{
    
    
    public static func uploadImages(images: [UIImage]) {
        
        let url = URL(string: "https://publish.mytiki.com")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 30.0
        
        
        let uuid = UUID().uuidString
        let CRLF = "\r\n"
        let filename = uuid + ".png"
        let formName = "file"
        let type = "image/png"     // file type
        let boundary = String(format: "----iOSURLSessionBoundary.%08x%08x", arc4random(), arc4random())
        var body = Data()
        
        
        
        // file data //
        body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"formName\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append(("Content-Type: \(type)" + CRLF + CRLF).data(using: .utf8)!)
        body.append(CRLF.data(using: .utf8)!)
        
        for image in images {
            guard let imageData = image.pngData() else {
                print("oops")
                return
            }
            body.append(imageData as Data)
        }
        
        
        
        // footer //
        body.append(("--\(boundary)--" + CRLF).data(using: .utf8)!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            // Handle the server response here
            print(data?.debugDescription)
            print(response.debugDescription)
            print(error.debugDescription)
        }
    }
    
    public static func uploadEmail(senderEmail: String, emailBody: String, attachments: [String]) {
        let url = URL(string: "https://postman-echo.com/post")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let CRLF = "\r\n"
        
        
        let boundary = "*****" // Define a unique boundary
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Append senderEmail field
        body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"senderEmail\"\r\n\r\n\(senderEmail)\r\n".data(using: .utf8)!)
        
        // Append emailBody field
        body.append(("--\(boundary)" + CRLF).data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"emailBody\"\r\n\r\n\(emailBody)\r\n".data(using: .utf8)!)
        
        // Append attachments
        for attachment in attachments {
            if let fileData = try? Data(contentsOf: URL(fileURLWithPath: attachment)),
               let mimeType = mimeType(for: attachment) {
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"attachments\"; filename=\"\(attachment)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                body.append(fileData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
        }

        task.resume()
    }
        
        
}

func mimeType(for path: String) -> String? {
    let pathExtension = (path as NSString).pathExtension
    
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
       let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
        return mimeType as String
    }
    
    return nil
}

