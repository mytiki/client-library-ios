/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct BottomSheetHeader: View{
    
    let title: String
    let subtitle: String
    let close: () -> Void
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack{
                Text(title)
                    .font(Rewards.theme.fontBold(size: 22))
                    .foregroundColor(Rewards.theme.primaryTextColor).frame(maxWidth: .infinity, alignment: .leading)
                Button(action: close) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                }
            }
            Text(subtitle)
                .font(Rewards.theme.fontMedium(size: 16))
                .foregroundColor(Rewards.theme.secondaryTextColor)
        }
    }
}
