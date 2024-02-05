/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct RetailerView: View{
    let provider: AccountProvider
    @State var account: Account? = nil
    @Binding var showAccountSheet: Bool
    let onAccount: (Account) -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: 0){
            RetailerCard(provider: provider)
                .padding(.top, 28)
            HStack(){
                Text("Account").font(Rewards.theme.fontBold(size: 28))
                Spacer()
            }
            .padding(.top, 24)
            RetailerScan()
                .padding(.top, 24)
            RetailerOffers(provider)
                .padding(.top, 30)
        }.asScreen(title: provider.name(), action: {showAccountSheet = false})
    }
}

