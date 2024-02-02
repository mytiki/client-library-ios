/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct EmailCard: View {
    var body: some View {
        VStack(spacing: 0){
            ZStack(){
                Rectangle()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(.white)
                    .shadow(color: Rewards.theme.secondaryBackgroundColor, radius: 0, x: 4, y: 4)
                TikiImages.gmail.resizable().frame(width: 100, height: 100)
            }.frame(width: 100, height: 100).background(.white).padding(.top, 24)
            Text("Gmail")
                .font(Rewards.theme.fontBold(size: 32))
                .padding(.top, 16)
            Text("When you connect your Gmail account, we auto-identify receipts and process available cashback rewards")
                .font(Rewards.theme.fontMedium(size: 14)).foregroundColor(Rewards.theme.secondaryTextColor)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 24)
        .asCard()
    }
}
