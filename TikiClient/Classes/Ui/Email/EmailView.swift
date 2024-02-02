/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct EmailView: View{
    
    let provider: EmailProviderEnum
    let onAccount: (Account) -> Void
    @State var accounts: [Account] = []
    @Binding var showAccountSheet: Bool
    
    
    init(provider: EmailProviderEnum, showAccountSheet: Binding<Bool>, onAccount: @escaping (Account) -> Void) {
        self.provider = provider
        self._showAccountSheet = showAccountSheet
        self.onAccount = onAccount
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0){
            EmailCard()
                .padding(.top, 28)
            EmailAccounts(accounts: $accounts){ removed in
                accounts.removeAll(where: {acc in removed == acc})
            }
            Text("Add Account").font(Rewards.theme.fontBold(size: 28)).padding(.top, 30)
            if(provider == .google){
                EmailLoginOAuth(accounts: $accounts).padding(.top, 24)
            }
            AccountLogin(provider: provider){ account in
                accounts.append(account)
            }
                .padding(.top, 32)
        }.asScreen(title: provider.rawValue, action: {showAccountSheet = false})
    }
}


