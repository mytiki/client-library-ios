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
                }) {
                    HStack (spacing: 5) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                        Text("Click to start")
                            .font(.system(size: 20, weight: .regular, design: .rounded)).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
}

