/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation
import AppAuth
import PDFKit

/// Service for managing email accounts.
public class EmailService {
    
    static var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    private var authState: OIDAuthState?
    public func setAuthState(_ state: OIDAuthState?){
        authState = state
    }
    
    public init(){}
    
    /// Logs in a user account using the provided credentials or initiates OAuth authentication for Gmail.
    ///
    /// - Parameters:
    ///   - account: An instance of the Account class containing user and account information.
    ///   - onError: A closure to handle error messages.
    ///   - onSuccess: A closure to handle success actions.
    public func login(_ provider:EmailProviderEnum, _ clientID: String, _ clientSecret: String = "", onComplete: (() -> Void)? = nil) {
        
        let configuration = OIDServiceConfiguration(
            authorizationEndpoint: provider.authorizationEndpoint(),
            tokenEndpoint: provider.tokenEndpoint())
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail, "https://www.googleapis.com/auth/gmail.readonly"],
                                              redirectURL: provider.deeplinkReturn(),
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        
        // performs authentication request
        print("Initiating authorization request with scope: \(request.scope ?? "nil")")
        
        EmailService.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
            
            if let authState = authState {
                self.setAuthState(authState)
                let authToken = AuthToken(auth: (authState.lastTokenResponse?.accessToken) ?? "",
                                          refresh: (authState.lastTokenResponse?.refreshToken) ?? "",
                                          provider: provider.rawValue,
                                          expiration: authState.lastTokenResponse?.accessTokenExpirationDate)
                
                
                // Get User Email Information
                
                let userinfoEndpoint = URL(string:provider.userInfoEndpoint())!
                
                // Add Bearer token to request
                var urlRequest = URLRequest(url: userinfoEndpoint)
                urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(authToken.auth)"]
                
                URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print(response)
                        return
                    }
                    do{
                        let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                    }catch{
                        print("error")
                    }
                    let dataReceived = String(data: data!, encoding: .utf8)
                    let decoder = JSONDecoder()
                    let body = dataReceived?.data(using: .utf8)
                    let emailOauthResponse = try! decoder.decode(EmailOauthResponse.self, from: body!)
                    
                    
                    EmailRepository.SaveEmailToken(authToken: authToken, email: emailOauthResponse.email)
                    onComplete?()
                    
                }.resume()
                
            } else {
                print("Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                self.setAuthState(nil)
                onComplete?()
            }
        }
        
        
    }
    
    /// Continue the OAuth authentication
    ///
    /// - Parameter provider: The email provider (GOOGLE or OUTLOOK).
    public static func continueOauthlogin(url: URL) {
        currentAuthorizationFlow?.resumeExternalUserAgentFlow(with: url)
        currentAuthorizationFlow = nil
    }
    
    public func refresh(_ provider:EmailProviderEnum,_ email: String,_ clientID: String, _ clientSecret: String = ""){
        
        let user = EmailRepository.ReadEmailToken(email: email)
        
        print("Initiating refresh authorization token request")
        
        // Get User Email Information
        let kRefreshTokenEndpoint = "https://www.googleapis.com/oauth2/v4/token?grant_type=refresh_token&refresh_token=\(user.refresh)&client_id=\(clientID)"
        
        let refreshTokenEndpoint = URL(string: kRefreshTokenEndpoint)!
        
        // Add Bearer token to request
        var urlRequest = URLRequest(url: refreshTokenEndpoint)
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print(response)
                return
            }
            do{
                let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
            }catch{
                print("error")
            }
            let dataReceived = String(data: data!, encoding: .utf8)
            let decoder = JSONDecoder()
            let body = dataReceived?.data(using: .utf8)
            let tokenRefreshed = try! decoder.decode(EmailOauthRefeshTokenResponse.self, from: body!)
            var date = Date.now
            date = date.addingTimeInterval(3600)
            let userAuthToken = AuthToken(auth: tokenRefreshed.access_token, refresh: user.refresh, provider: provider.rawValue, expiration: date)
            
            EmailRepository.UpdateEmailToken(authToken: AuthToken(auth: tokenRefreshed.access_token, refresh: user.refresh, provider: provider.rawValue, expiration: date), email: email)
            
        }.resume()
        
        
    }
    
    public static func verifyStatus(email: String) -> AccountStatus {
        return AccountStatus.verified
    }
    
    /// Retrieves the list of connected email accounts.
    ///
    /// - Returns: List of connected email accounts.
    public static func accounts() -> [Account] {
        var accounts = Account.toAccount(accounts: EmailRepository.ReadAllEmail())
        return accounts
    }
    
    /// Retrieves the list of connected email accounts.
    ///
    /// - Returns: List of connected email accounts.
    public func account(email: String) -> AuthToken {
        return EmailRepository.ReadEmailToken(email: email)
    }
    
    /// Removes a previously added email account.
    ///
    /// - Parameter email: The email account to be removed.
    public static func logout(email: String) {
        EmailRepository.DeleteEmailToken(email: email)
    }
    
    public static func getEmail(email: String){
        let userToken = EmailRepository.ReadEmailToken(email: email)
        
        var lastDateEmailRead = UserDefaults.standard.object(forKey: "lastEmailRead")
        
        let lastIndexDate = UserDefaults.standard.object(forKey: "lastIndexDate") as? Date
        
        let lastEmailDateRead = lastDateEmailRead != nil ? Date(timeIntervalSince1970: (Double(lastDateEmailRead as! String)!/1000.0)) : Date.distantPast
        
                    
        
        var formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
                
        var lastEmailDateReadFormatted = formater.string(from: lastEmailDateRead)
        
        var kEmailListMessages = ""
        
        var test = lastIndexDate?.timeIntervalSinceNow
        
        print(test?.description)
        
        var arrayLenth = 0
        var listSender = Sender.returnList()
        
        for senderLenth in 1...15 {
            var senderList = ""
            if(senderLenth == 15){
                for sender in listSender[1400...1427] {
                    if(sender.email == listSender[1427].email){
                        senderList += "from:" + sender.email
                    }else{
                        senderList += "from:" + sender.email + " "
                    }
                }
                print(senderList)
                if(lastIndexDate?.timeIntervalSinceNow ?? 0 < -21.600){
                    print("Time interval is less then 6h")
                    
                    var anualScrape = formater.string(from: lastEmailDateRead.addingTimeInterval(-31536000))
                    
                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=\(senderList)"
//                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=newer:\(anualScrape)older:\(lastEmailDateReadFormatted)list:\(senderList)"
                    print(anualScrape)
                    print(lastEmailDateReadFormatted)
                    print("already read email")
                }
                
                if(lastDateEmailRead != nil && lastIndexDate?.timeIntervalSinceNow ?? 0 > -21.600){
//                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=newer:2024/05/01older:\(lastEmailDateReadFormatted)list:\(senderList)"
                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=\(senderList)"
                    print("already read email")
                    print(lastEmailDateReadFormatted)
                    print(kEmailListMessages)
                }
                if(lastDateEmailRead == nil){
                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q={\(senderList)}"
                    print("don`t read email yet")
                }
                // Get Email List Messages
                
                let emailListMessages = URL(string: kEmailListMessages)!

                  // Add Bearer token to request
                var urlRequest = URLRequest(url: emailListMessages)
                urlRequest.httpMethod = "GET"
                urlRequest.addValue("Bearer \(userToken.auth)", forHTTPHeaderField: "Authorization")
                print(urlRequest.description)
                
                DispatchQueue.main.async {
                    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            print(response)
                            let dataReceived = String(data: data!, encoding: .utf8)
                            return
                        }
                        do{
                            let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                        }catch{
                            print("error")
                        }
                        let dataReceived = String(data: data!, encoding: .utf8)
                        let decoder = JSONDecoder()
                        let body = dataReceived?.data(using: .utf8)
                        if let emailListResponse = try? decoder.decode(EmailListResponse.self, from: body!) {
                            let encoder = JSONEncoder()
                            if let encodedEmailMessageList = try? encoder.encode(emailListResponse.messages){
                                UserDefaults.standard.set(encodedEmailMessageList, forKey: "emailMessageList")
                            }
                            if let savedEmailList = UserDefaults.standard.object(forKey: "emailMessageList") as? Data{
                                if let savedEmailList = try? decoder.decode(EmailListResponse.self, from: savedEmailList){

                                }
                            }
                            // salvar data do ultimo email
                            guard let nextPageToken = emailListResponse.nextPageToken else {
                                UserDefaults.standard.set(Date.now, forKey: "lastIndexDate")
                                self.getEmailMensages(emailToken: email)
                                return
                            }
                            UserDefaults.standard.set(Date.now, forKey: "lastIndexDate")
                            getEmailMensages(emailToken: email)
                            keepGetEmailList(email: email, userToken: userToken.auth, pageToken: nextPageToken)
                        }else{
                            print("dont receive messages")
                            return
                        }
                   
                    }.resume()
                }
            }else {
                for sender in listSender[((senderLenth-1)*100)...senderLenth*100] {
                    if(sender.email == listSender[senderLenth*100].email){
                        senderList += "from:" + sender.email
                    }else{
                        senderList += "from:" + sender.email + " "
                    }
                }
                if(lastIndexDate?.timeIntervalSinceNow ?? 0 < -21.600){
                    print("Time interval is less then 6h")
                    
                    var anualScrape = formater.string(from: lastEmailDateRead.addingTimeInterval(-31536000))
                    
//                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=newer:\(anualScrape)older:\(lastEmailDateReadFormatted)list:\(senderList)"
                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=\(senderList)"
                    print(anualScrape)
                    print(lastEmailDateReadFormatted)
                    print("already read email")
                }
                
                if(lastDateEmailRead != nil && lastIndexDate?.timeIntervalSinceNow ?? 0 > -21.600){
//                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=newer:2024/05/01older:\(lastEmailDateReadFormatted)list:\(senderList)"
                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q=\(senderList)"
                    print("already read email")
                    print(lastEmailDateReadFormatted)
                    print(kEmailListMessages)
                }
                if(lastDateEmailRead == nil){
                    kEmailListMessages = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500&q={\(senderList)}"
                    print("don`t read email yet")
                }
                // Get Email List Messages
                
                let emailListMessages = URL(string: kEmailListMessages)!

                  // Add Bearer token to request
                var urlRequest = URLRequest(url: emailListMessages)
                urlRequest.httpMethod = "GET"
                urlRequest.addValue("Bearer \(userToken.auth)", forHTTPHeaderField: "Authorization")
                print(urlRequest.description)
                
                DispatchQueue.main.async {
                    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            print(response)
                            let dataReceived = String(data: data!, encoding: .utf8)
                            return
                        }
                        do{
                            let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                        }catch{
                            print("error")
                        }
                        let dataReceived = String(data: data!, encoding: .utf8)
                        let decoder = JSONDecoder()
                        let body = dataReceived?.data(using: .utf8)
                        if let emailListResponse = try? decoder.decode(EmailListResponse.self, from: body!) {
                            let encoder = JSONEncoder()
                            if let encodedEmailMessageList = try? encoder.encode(emailListResponse.messages){
                                UserDefaults.standard.set(encodedEmailMessageList, forKey: "emailMessageList")
                            }
                            if let savedEmailList = UserDefaults.standard.object(forKey: "emailMessageList") as? Data{
                                if let savedEmailList = try? decoder.decode(EmailListResponse.self, from: savedEmailList){

                                }
                            }
                            // salvar data do ultimo email
                            guard let nextPageToken = emailListResponse.nextPageToken else {
                                UserDefaults.standard.set(Date.now, forKey: "lastIndexDate")
                                self.getEmailMensages(emailToken: email)
                                return
                            }
                            UserDefaults.standard.set(Date.now, forKey: "lastIndexDate")
                            getEmailMensages(emailToken: email)
                            keepGetEmailList(email: email, userToken: userToken.auth, pageToken: nextPageToken)
                        }else{
                            print("dont receive messages")
                            return
                        }
                   
                    }.resume()
                }
            }
        }
        
        


    }
    public static func keepGetEmailList(email: String, userToken: String, pageToken: String){
        UserDefaults.standard.set(Date.now, forKey: "dateStartList")
        UserDefaults.standard.set(pageToken, forKey: "lastNextPageToken")
        
        let userToken = EmailRepository.ReadEmailToken(email: email)
        let kEmailListMessageEndpoint = "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=500"

        var components = URLComponents(string: kEmailListMessageEndpoint)!
        components.queryItems = [URLQueryItem(name: "pageToken", value: pageToken)]

        if let kEmailListMessageEndpoint = components.url {
            // Add Bearer token to request
            var urlRequest = URLRequest(url: kEmailListMessageEndpoint)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("Bearer \(userToken.auth)", forHTTPHeaderField: "Authorization")
            print(urlRequest.description)
            
            DispatchQueue.main.async {
                URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print(response)
                        let dataReceived = String(data: data!, encoding: .utf8)
                        return
                    }
                    do{
                        let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                    }catch{
                        print("error")
                    }
                    let dataReceived = String(data: data!, encoding: .utf8)
                    let decoder = JSONDecoder()
                    let body = dataReceived?.data(using: .utf8)
                    if(body != nil) {
                        let emailListResponse = try! decoder.decode(EmailListResponse.self, from: body!)
                        let encoder = JSONEncoder()
                        if let savedEmailList = UserDefaults.standard.object(forKey: "emailMessageList") as? Data{
                            if let savedEmailList = try? decoder.decode([MessageResponse].self, from: savedEmailList){
                                var emailMessageList = savedEmailList
                                emailMessageList.append(contentsOf: emailListResponse.messages)
                                if let encodedEmailMessageList = try? encoder.encode(emailMessageList){
                                    UserDefaults.standard.set(encodedEmailMessageList, forKey: "emailMessageList")
                                }
                                guard let nextPageToken = emailListResponse.nextPageToken else {
                                    UserDefaults.standard.set(nil, forKey: "lastNextPageToken")
                                    UserDefaults.standard.set(Date.now, forKey: "lastIndexDate")
                                    getEmailMensages(emailToken: email)

                                    return
                                }
                                UserDefaults.standard.set(nextPageToken, forKey: "lastNextPageToken")
                                UserDefaults.standard.set(Date.now, forKey: "lastIndexDate")
                                getEmailMensages(emailToken: email)
                                self.keepGetEmailList(email: email, userToken: userToken.auth, pageToken: nextPageToken)

                            }
                        }
                    }

                    
                    

                    
                }.resume()
            }

        }
 

    }

    public static func getEmailMensages(emailToken: String){
        let decoder = JSONDecoder()
        var lastPartId: String = ""
        if let savedEmailList = UserDefaults.standard.object(forKey: "emailMessageList") as? Data{
            if let savedEmailList = try? decoder.decode([MessageResponse].self, from: savedEmailList){
                for email in savedEmailList {
                    
                    print("Get email message \(email.id)")
                    
                    var fileBase64: String = ""
                    let userToken = EmailRepository.ReadEmailToken(email: emailToken)
                    
                    
                    // Get User Email Information
                    let kEmailListMessageEndpoint = "https://gmail.googleapis.com/gmail/v1/users/me/messages/\(email.id)"
                    
                    let emailListMessageEndpoint = URL(string: kEmailListMessageEndpoint)!

                      // Add Bearer token to request
                    var urlRequest = URLRequest(url: emailListMessageEndpoint)
                    urlRequest.httpMethod = "GET"
                    urlRequest.addValue("Bearer \(userToken.auth)", forHTTPHeaderField: "Authorization")
                    print(urlRequest.description)
                    
                    DispatchQueue.main.async {
                        URLSession.shared.dataTask(with: urlRequest)  { data, response, error in
                                guard let httpResponse = response as? HTTPURLResponse,
                                      (200...299).contains(httpResponse.statusCode) else {
                                    print(response)
                                    let dataReceived = String(data: data!, encoding: .utf8)
                                    return
                                }
                                do{
                                    let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                                }catch{
                                    print("error")
                                }
                                let dataReceived = String(data: data!, encoding: .utf8)
                                let decoder = JSONDecoder()
                                let body = dataReceived?.data(using: .utf8)
                                let emailContentResponse = try! decoder.decode(MessageResponse.self, from: body!)
                            
                                // Save the date of the last email read
                                let lastDateEmailRead = UserDefaults.standard.object(forKey: "lastEmailRead")
                                let lastEmailDateRead = lastDateEmailRead != nil ? Date(timeIntervalSince1970: (Double(lastDateEmailRead as! String)!/1000.0)) : Date.distantPast
                                var actualEmailReal = Date(timeIntervalSince1970: (Double(emailContentResponse.internalDate!)!/1000.0))
                                let timeInterval = actualEmailReal.timeIntervalSince(lastEmailDateRead)
                                if(timeInterval < 0){
                                    UserDefaults.standard.set(emailContentResponse.internalDate, forKey: "lastEmailRead")
                                }
                            
                            
                            if let savedEmailList2 = UserDefaults.standard.object(forKey: "emailMessageList") as? Data{
                                if var savedEmailList2 = try? decoder.decode([MessageResponse].self, from: savedEmailList2){
                                    if let idx = savedEmailList2.firstIndex(where: {$0 == email} ) {
                                        savedEmailList2.remove(at: idx)
                                        let encoder = JSONEncoder()
                                        if let encodedsavedEmailList2 = try? encoder.encode(savedEmailList2){
                                            UserDefaults.standard.set(encodedsavedEmailList2, forKey: "emailMessageList")
                                        }
                                    }
                                }
                            }

                                if(emailContentResponse.payload?.parts != nil){
                                    fileBase64 += emailContentResponse.payload?.body?.data ?? ""
                                    for messagePart in emailContentResponse.payload!.parts! {
                                        fileBase64 += messagePart.body?.data ?? ""
                                        if(messagePart.mimeType == "image/png"){
                                            var kEmaiMessageAttaachmentEndpoint: String = "https://gmail.googleapis.com/gmail/v1/users/me/messages/\(emailContentResponse.id)/attachments/\(messagePart.body!.attachmentId!)"
                                            let emaiMessageAttaachmentEndpoint = URL(string: kEmaiMessageAttaachmentEndpoint)!
                                            var urlRequest = URLRequest(url: emaiMessageAttaachmentEndpoint)
                                            urlRequest.httpMethod = "GET"
                                            urlRequest.addValue("Bearer \(userToken.auth)", forHTTPHeaderField: "Authorization")
                                            print(urlRequest.description)
                                            
                                            DispatchQueue.main.async {
                                                URLSession.shared.dataTask(with: urlRequest)  { data, response, error in
                                                    guard let httpResponse = response as? HTTPURLResponse,
                                                          (200...299).contains(httpResponse.statusCode) else {
                                                        print(response)
                                                        let dataReceived = String(data: data!, encoding: .utf8)
                                                        return
                                                    }
                                                    do{
                                                        let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                                                    }catch{
                                                        print("error")
                                                    }
                                                    let dataReceived = String(data: data!, encoding: .utf8)
                                                    let decoder = JSONDecoder()
                                                    let body = dataReceived?.data(using: .utf8)
                                                    let emailContentResponse = try! decoder.decode(MessagePartBodyResponse.self, from: body!)
                                                    var base64Url = base64urlToBase64(base64url: emailContentResponse.data!)
                                                    var image = base64Convert(base64String: base64Url)
                                                    if let base64Encoded = Data(base64Encoded: emailContentResponse.data!) {
                                                        if let image = UIImage(data: base64Encoded) {
                                                            print("Image Get")
                                                            // Use the `image` object
                                                        }
                                                    }
                                                    print(data?.debugDescription)
                                                }.resume()
                                            }

                                        }
                                        if(messagePart.mimeType == "application/pdf"){
                                            var kEmaiMessageAttaachmentEndpoint: String = "https://gmail.googleapis.com/gmail/v1/users/me/messages/\(emailContentResponse.id)/attachments/\(messagePart.body!.attachmentId!)"
                                            let emaiMessageAttaachmentEndpoint = URL(string: kEmaiMessageAttaachmentEndpoint)!
                                            var urlRequest2 = URLRequest(url: emaiMessageAttaachmentEndpoint)
                                            urlRequest2.httpMethod = "GET"
                                            urlRequest2.addValue("Bearer \(userToken.auth)", forHTTPHeaderField: "Authorization")
                                            print(urlRequest.description)
                                            
                                            URLSession.shared.dataTask(with: urlRequest2)  { data, response, error in
                                                guard let httpResponse = response as? HTTPURLResponse,
                                                      (200...299).contains(httpResponse.statusCode) else {
                                                    print(response)
                                                    let dataReceived = String(data: data!, encoding: .utf8)
                                                    return
                                                }
                                                do{
                                                    let receivedData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: String]
                                                }catch{
                                                    print("error")
                                                }
                                                let dataReceived = String(data: data!, encoding: .utf8)
                                                let decoder = JSONDecoder()
                                                let body = dataReceived?.data(using: .utf8)
                                                let emailContentResponse = try! decoder.decode(MessagePartBodyResponse.self, from: body!)
                                                var base64 = base64urlToBase64(base64url: emailContentResponse.data!)
                                                saveBase64StringToPDF(base64)
                                                print(data?.debugDescription)
                                            }.resume()
                                        }
                                    }
                                    decodeMessageAttachment(attachmentBody: fileBase64)
                                }
                                else if(emailContentResponse.payload?.body?.data != nil){
                                    decodeMessageAttachment(attachmentBody: (emailContentResponse.payload?.body?.data)!)
                                }

                                
                                
                            }.resume()
                    }
                    

                }
            }
        }
    }
    public static func clearEmailIndexList(email: String){
        UserDefaults.standard.set(nil, forKey: "emailMessageList")
    }
    
    public static func decodeMessageAttachment(attachmentBody: String){
        print(attachmentBody.base64Decoded()?.description)

    }
    
    public static func base64Convert(base64String: String?) -> UIImage{
       if (base64String?.isEmpty)! {
           return #imageLiteral(resourceName: "kohls.png")
       }else {
           // !!! Separation part is optional, depends on your Base64String !!!
           let temp = base64String?.components(separatedBy: ",")
           let dataDecoded : Data = Data(base64Encoded: temp![0], options: .ignoreUnknownCharacters)!
           let decodedimage = UIImage(data: dataDecoded)
           return decodedimage!
       }
     }
    
    static func base64urlToBase64(base64url: String) -> String {
        var base64 = base64url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return base64
    }
    
    static func saveBase64StringToPDF(_ base64String: String) {
        guard
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last,
            let convertedData = Data(base64Encoded: base64String)
        else {
            return
        }
        
        documentsURL.appendPathComponent("document.pdf")
        
        do {
//            try convertedData.write(to: documentsURL)
//            let pdfView = PDFView()
//            print("PDF saved successfully at: \(documentsURL)")
////            if let resourceUrl = Bundle.main.url(forResource: "document.pdf", withExtension: "pdf") {
//                if let document = PDFDocument(url: documentsURL) {
//                    pdfView.document = document
//                    print("Document successfully save")
//                }else {
//                    return
//                }
////            }
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
        }
    }
}
