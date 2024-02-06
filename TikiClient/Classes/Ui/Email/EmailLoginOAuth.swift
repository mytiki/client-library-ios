/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct EmailLoginOAuth: View {
    
    @Binding var accounts: [Account]
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            TikiImages.googleAuth
                .resizable()
                .frame(height: 70)
                .onTapGesture {

                }.padding(.top, 22)
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
