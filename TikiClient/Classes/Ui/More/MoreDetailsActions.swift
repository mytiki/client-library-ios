/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct MoreDetailsActions: View {
    let showTerms: () -> Void
    let onLicenseDeclined: () -> Void

    var body: some View {
        VStack(spacing: 0){
            Rewards.theme.secondaryTextColor.frame(height: 4 / UIScreen.main.scale)
            Link(destination: URL(string: "https://www.apple.com")!) {
                HStack() {
                    Text("Report an issue").font(Rewards.theme.fontMedium(size: 16)).foregroundColor(Rewards.theme.secondaryTextColor)
                    Spacer()
                    TikiImages.grayAlert.resizable().frame(width: 18, height: 18)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            Rewards.theme.secondaryTextColor.frame(height: 4 / UIScreen.main.scale)
            HStack() {
                Text("Data licensing agreement").font(Rewards.theme.fontMedium(size: 16)).foregroundColor(Rewards.theme.secondaryTextColor)
                Spacer()
                TikiImages.handStop.resizable().frame(width: 18, height: 18)
            }
            .onTapGesture {
                showTerms()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            Rewards.theme.secondaryTextColor.frame(height: 4 / UIScreen.main.scale)
            HStack() {
                Text("Opt out of Cashback Connections").font(Rewards.theme.fontMedium(size: 16)).foregroundColor(.tikiRed)
                Spacer()
                TikiImages.redStop.resizable().frame(width: 18, height: 18)
            }.onTapGesture {
                onLicenseDeclined()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
        }
    }
}
