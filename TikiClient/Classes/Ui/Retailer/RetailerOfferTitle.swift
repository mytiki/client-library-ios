/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct RetailerOfferTile: View {
    
    let offer: RetailerOffer
    
    var body: some View {
        Link(destination: offer.url){
            HStack(){
                TikiImages.from(offer.provider.name())
                    .resizable()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Rewards.theme.secondaryBackgroundColor, radius: 0, x: 2, y: 2)
                    .padding(.trailing, 24)
                Text(offer.description).font(Rewards.theme.fontMedium(size: 15)).foregroundStyle(Rewards.theme.secondaryTextColor).padding(.trailing, 20)
                Spacer()
                TikiImages.arrow_right
                    .resizable()
                    .frame(width: 36, height: 36)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 24)
        }
    }
}
