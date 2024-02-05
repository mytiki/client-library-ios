/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct EmailLoginOAuth: View {
    
    @Binding var accounts: [Account]
    let provider: AccountProvider

    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            if(provider.name() == "Google"){
                TikiImages.googleAuth
                    .resizable()
                    .frame(height: 70)
                    .onTapGesture {
                        print("TODO Google OAuth")
                    }.padding(.top, 22)
            }
            if(provider.name() == "Outlook"){
                TikiImages.microsoftOauth
                    .resizable()
                    .frame(height: 70)
                    .onTapGesture {
                        print("TODO Microsoft OAuth")
                    }.padding(.top, 22)
            }
            HStack(){
                VStack{
                    Divider()
                        .frame(height: 1)
                        .overlay(Rewards.theme.secondaryTextColor)
                }
            }.padding(.top, 32)
        }
    }
}
