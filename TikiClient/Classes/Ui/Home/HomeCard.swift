/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation
import SwiftUI

public struct HomeCard: View {
    @State var progress: Double = 0.25
    @Binding var showMoreSheet: Bool
    
    public var body: some View {
        let earnings = Rewards.license.earnings()
      let rating = String(format: "%.2f", earnings.rating)
      let bonus = String(format: "%.2f", earnings.bonus)
      let total = String(format: "%.2f", earnings.total)
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0){
                Text("Month").font(Rewards.theme.fontMedium(size: 14))
                    .foregroundColor(Rewards.theme.primaryTextColor)
                    .padding(.bottom, 3)
                Text("$\(rating) / $\(bonus)").font(SpaceGrotesk.bold(size: 18))
                    .foregroundColor(Rewards.theme.accentColor)
                    .padding(.bottom, 12)
                Text("Lifetime").font(Rewards.theme.fontMedium(size: 14))
                    .foregroundColor(Rewards.theme.primaryTextColor)
                    .padding(.bottom, 3)
                Text("$\(total)").font(SpaceGrotesk.bold(size: 18))
                    .foregroundColor(Rewards.theme.secondaryTextColor)
                    .padding(.bottom, 12)
                Button {
                    showMoreSheet = true
                } label: {
                    HStack(spacing: 0) {
                        Text("Show More")
                            .foregroundColor(Rewards.theme.accentColor)
                            .font(Rewards.theme.fontBold(size: 18))
                            .lineLimit(1)
                        Image(systemName: "arrow.forward")
                            .padding(.leading, 5)
                            .foregroundColor(Rewards.theme.accentColor)
                    }
                }
            }
            Spacer()
            CircularProgressView(progress: progress, progress2: nil, progress3: nil )
              .frame(width: 80, height: 80)
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 31)
        .padding(.trailing, 41)
        .padding(.vertical, 24)
        .asCard()
    }
}

