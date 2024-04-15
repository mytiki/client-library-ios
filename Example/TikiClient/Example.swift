/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import PhotosUI

import SwiftUI
import TikiClient

@main
struct Main: App {
    
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    
    @State public var publishImageId: String? = nil
        
    var license = License()
    var body: some Scene {
        WindowGroup {
            VStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                }
                Button("Open camera") {
                    TikiClient.capture.scan(onImage: { image in
                        selectedImage = image
                        TikiClient.auth.token(providerId: "", secret: "", scopes: ["publish"], completion: { token, error  in
                            TikiClient.capture.publish(images: [image!], token: token!, completion: { publishId, error2 in
                                if(error == nil){
                                    publishImageId = publishId
                                }
                                
                            })
                            
                        })

                    })
                }.padding(.bottom, 2)
                Button("Create License") {
                    print(TikiClient.createLicense(completion: { message in
                        print(message)
                        
                    }))
                }.padding(.bottom, 2)
                Button("Initialize") {
                    TikiClient.initialize(userId: "JesseLegal222", completion: { message in
                        print(message)
                    })
                }.padding(.bottom, 2)
                Button("configuration") {
                    TikiClient.configuration(config:  Config(providerId: "8204cd6f-5b6c-4ddb-be14-dd5605c6a745", publicKey: "MIIBCgKCAQEAtk9JrSBKdppHhXx+pU7JTd7dGpv+Q6idZIUW6Aot7sYFYu+n4tr7YfKNpNHdor/Yujqfg9wPU2MOWTPiXbgH9nwnQLBM7o8szijIVY7J1GjlmGosEF0uk9/FZiE/FZY+R0+MqKd2kKEkeNddV94Jf8U683yZofFjfqEdW16cWUP5aAT1NBmemeTcbzZGlDGk3OebuPFPKnBulZrDCdkDdmGMJfmZvSp7XTbu91xV2Ff0VnxWlOMFi2AQVZ0F15QliXYnkA7zYWBBCP+lsE0V5tPqtL5jMg/fJI411Ez9x0rycoAXY7dfjKloZVw3mJdu1KAbkJDmk7TlymIvqeVL4QIDAQAB", companyName:  "jesse", companyJurisdiction: "USA", tosUrl: "www.jessemonteiro.com", privacyUrl: "www.jessemonteiro.com"))
                }.padding(.bottom, 2)
                Button("Verify Capture Upload Image") {
                    TikiClient.auth.token(providerId: "", secret: "", scopes: ["publish"], completion: { token, error  in
                        TikiClient.capture.receipt(receiptId: publishImageId!, token: token!, completion: { message, error  in
                            print(message)
                            
                        })
                    })
                }.padding(.bottom, 2)
            }
        }
    }
}
