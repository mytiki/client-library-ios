/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import SwiftUI


public struct MoreAccounts: View {
    public let onAccountSelect: (Account) ->  Void
    public var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    let accountList: [Account]
    
    public var body: some View {
        if(!accountList.isEmpty){
            Text("Accounts").font(Rewards.theme.fontBold(size: 28))
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(accountList, id: \.hashValue){ acc in
                    VStack() {
                        AccountIcon(provider: acc.provider, status: acc.status, width: 80, height: 80)
                        Text(acc.provider.name()).font(SpaceGrotesk.medium(size: 12)).foregroundColor(Rewards.theme.secondaryTextColor)
                    }.onTapGesture {
                        onAccountSelect(acc)
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 32)
            .asCard()
        }
    }
}
