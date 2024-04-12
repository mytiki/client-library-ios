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
        
    var license = License()
//    @State var isInitialized = false
//    @State var startBtnEnabled = true
//    @State var username: String = ""
//    @State var password: String = ""
//    @State var publickey: SecKey?
//    let authService = AuthService()
//    let clientSecret = "MIIBCgKCAQEAu97z7Ot6V6yCKwZR1ETGLfGI5e2ppL/jhbg1yPuBW1cbgB00N7QcJzjq4eevNWq+83BDXIVlJK5xmC4CquyIJxr9wlAqg389+5Srws3gfaa51LqyzcSzN6fLrGB2w7s7kgSHwvI1oDhhAsL6GDzoW91MysEKxbByMQkZ+Fqgum10JxUVgS18rVgw62zG/2BL1qxdwNR6rxc4gC7p2WOHNoO5IGwaQy3vq3qKLlswsoafl2V9CpQYnQb5a2ZeXvcFufE854pu+Hg7Kchs/zSHy+zJajbGl9qwIAYgQ/Oh+ZywzVh5sUIlK5gLgjRKp5j31ufqjAwhXEJxeBJQZTeb/QIDAQAB"
//    let providerId = "c3e41a00-f9a3-4593-a3c6-f6cbb3b6c7de"

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
                    })
                }.padding(.bottom, 2)
                Button("Create License") {
                    print(TikiClient.createLicense())
                }.padding(.bottom, 2)
                Button("Initialize") {
                    TikiClient.initialize(userId: "JesseLegal222")
                }.padding(.bottom, 2)
                Button("configuration") {
                    TikiClient.configuration(config:  Config(providerId: "8204cd6f-5b6c-4ddb-be14-dd5605c6a745", publicKey: "MIIBCgKCAQEAtk9JrSBKdppHhXx+pU7JTd7dGpv+Q6idZIUW6Aot7sYFYu+n4tr7YfKNpNHdor/Yujqfg9wPU2MOWTPiXbgH9nwnQLBM7o8szijIVY7J1GjlmGosEF0uk9/FZiE/FZY+R0+MqKd2kKEkeNddV94Jf8U683yZofFjfqEdW16cWUP5aAT1NBmemeTcbzZGlDGk3OebuPFPKnBulZrDCdkDdmGMJfmZvSp7XTbu91xV2Ff0VnxWlOMFi2AQVZ0F15QliXYnkA7zYWBBCP+lsE0V5tPqtL5jMg/fJI411Ez9x0rycoAXY7dfjKloZVw3mJdu1KAbkJDmk7TlymIvqeVL4QIDAQAB", companyName:  "jesse", companyJurisdiction: "USA", tosUrl: "www.jessemonteiro.com", privacyUrl: "www.jessemonteiro.com"))
                }.padding(.bottom, 2)
            }
        }
    }
}
