/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct RetailerOffers: View {
    
    let offers: [RetailerOffer]
    
    init(_ provider: AccountProvider){
        self.offers = Rewards.capture.offers(provider: provider)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("More Offers").font(Rewards.theme.fontBold(size: 28))
        }
        ForEach(offers, id: \.description){ offer in
            RetailerOfferTile(offer: offer)
        }
    }
}

