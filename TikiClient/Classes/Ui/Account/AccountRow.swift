/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct AccountRow: View {
    
    let acc: Account
    let onRemove: (Account) -> Void
    
    var body: some View {
        HStack(spacing: 0){
            AccountIcon(provider: acc.provider, status: acc.status, width: 56, height: 56)
                .padding(.trailing, 24)
            VStack(alignment: .leading, spacing: 0){
                Text(acc.provider.rawValue)
                    .font(Rewards.theme.fontBold(size: 24))
                    .foregroundStyle(acc.status == .unverified ? Color.tikiRed : Rewards.theme.secondaryTextColor)
                Text(acc.username)
                    .font(Rewards.theme.fontMedium(size: 20))
                    .foregroundStyle(acc.status == .unverified ? Color.tikiRed : Rewards.theme.secondaryTextColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer()
            Button(action: {
                do{
   
                }catch{
                    print("logout error")
                }
            }){
                TikiImages.minus
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}
