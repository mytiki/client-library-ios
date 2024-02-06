/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import SwiftUI

struct EmailAccounts: View {
    
    @Binding var accounts: [Account]
    let onRemove:(Account) -> Void
    
    var body: some View {
        if(!accounts.isEmpty){
            VStack(alignment: .leading, spacing: 0){
                Text("Accounts").font(Rewards.theme.fontBold(size: 28))
                    .padding(.top, 24)
                ForEach(accounts, id: \.hashValue){ acc in
                    AccountRow(acc: acc, onRemove: onRemove)
                        .padding(.top, 24)
                }
            }
        }
    }
}
