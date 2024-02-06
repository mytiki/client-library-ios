/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import SwiftUI

struct MoreDetailsData: View {
    var body: some View {
        VStack(spacing: 0){
            Text("What data do we collect?").font(Rewards.theme.fontBold(size: 18))
                .foregroundColor(Rewards.theme.secondaryTextColor)
            Text("Learn about how your data powers your Cashback Connections")
                .font(Rewards.theme.fontMedium(size: 12))
                .foregroundColor(Rewards.theme.secondaryTextColor)
                .multilineTextAlignment(.center)
            HStack(){
                HStack(){
                    TikiImages.purchases.resizable().frame(width: 18, height: 18)
                    Text("Purchases").font(Rewards.theme.fontMedium(size: 16)).foregroundColor(Rewards.theme.secondaryTextColor)
                }
                Spacer()
                HStack(){
                    TikiImages.receipts.resizable().frame(width: 18, height: 18)
                    Text("Receipts").font(Rewards.theme.fontMedium(size: 16)).foregroundColor(Rewards.theme.secondaryTextColor)
                }
            }.padding(.top, 24)
            HStack(){
                HStack(){
                    TikiImages.userId.resizable().frame(width: 18, height: 18)
                    Text("User ID").font(Rewards.theme.fontMedium(size: 16)).foregroundColor(Rewards.theme.secondaryTextColor)
                }
                Spacer()
            }.padding(.top, 12)
        }.frame(width: 250)
    }
}

