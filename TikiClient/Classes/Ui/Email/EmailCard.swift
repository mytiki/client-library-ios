/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct EmailCard: View {
    let provider: AccountProvider

    var body: some View {
        VStack(spacing: 0){
            ZStack(){
                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(.white)
                    .shadow(color: Rewards.theme.secondaryBackgroundColor, radius: 0, x: 4, y: 4)
                let name = provider.name()
                if(name == "Google"){
                    TikiImages.gmail.resizable().frame(width: 100, height: 100)
                }
                if(provider.name() == "Outlook"){
                    TikiImages.outlook.resizable().frame(width: 100, height: 100)
                }

            }.frame(width: 100, height: 100).background(.white).padding(.top, 24)
            Text(provider.name())
                .font(Rewards.theme.fontBold(size: 32))
                .padding(.top, 16)
            Text("When you connect your \(provider.name().capitalized(with: .current)) account, we auto-identify receipts and process available cashback rewards")
                .font(Rewards.theme.fontMedium(size: 14)).foregroundColor(Rewards.theme.secondaryTextColor)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 24)
        .asCard()
    }
}
