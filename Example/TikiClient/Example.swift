/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */


import SwiftUI
import TikiClient

@main
struct RewardsExampleApp: App {
    
    @State var isInitialized = false
    @State var startBtnEnabled = true
    @State var username: String = ""
    @State var password: String = ""
    let emailService = EmailService()
    
    var body: some Scene {
        WindowGroup {
            if( !isInitialized ) {
                Button(action: {
                    emailService.login(.google, "252743744388-u57lenibhl7nr8q50d4e1dfjd36am22q.apps.googleusercontent.com")
//                    emailService.login(.outlook, "dd0d9b1e-a128-434c-911e-3c79df961b9b")
                }) {
                    HStack (spacing: 5) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        Text("Click to Login")
                            .font(.system(size: 20, weight: .regular, design: .rounded)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.padding(.bottom, 25)
                Button(action: {
                    emailService.refresh(.google, "jessemonteiroferreira@gmail.com", "252743744388-u57lenibhl7nr8q50d4e1dfjd36am22q.apps.googleusercontent.com")
//                    emailService.login(.outlook, "dd0d9b1e-a128-434c-911e-3c79df961b9b")
                }) {
                    HStack (spacing: 5) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        Text("Click to Refresh Token")
                            .font(.system(size: 20, weight: .regular, design: .rounded)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.padding(.bottom, 25)
                Button(action: {
                    emailService.logout(email: "email")
                }) {
                    HStack (spacing: 5) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        Text("Click to Remove Token")
                            .font(.system(size: 20, weight: .regular, design: .rounded)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.padding(.bottom, 25)
                Button(action: {
                    print(emailService.accounts())
                }) {
                    HStack (spacing: 5) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        Text("Click to Receive Accounts")
                            .font(.system(size: 20, weight: .regular, design: .rounded)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }.padding(.bottom, 25)
                Button(action: {
                    Rewards.config(terms: "Terms for testing", clientId: "clientId", clientSecret: "")
                    try? Rewards.show(userId: "")
                }) {
                    HStack (spacing: 5) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        Text("Click to open Rewards App")
                            .font(.system(size: 20, weight: .regular, design: .rounded)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
}

