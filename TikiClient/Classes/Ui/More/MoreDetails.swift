/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

struct MoreDetails: View {
    let showTerms: () -> Void
    let onLicenseDeclined: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Program Details").font(Rewards.theme.fontBold(size: 28))
            VStack(alignment: .center, spacing: 0){
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 36, height: 36, alignment: .center)
                    .foregroundColor(Rewards.theme.accentColor)
                    .padding(.vertical, 24)
                MoreDetailsData()
                    .frame(width: 275)
                    .padding(.horizontal, 36.5)
                MoreDetailsUse()
                    .padding(.top, 48)
                MoreDetailsActions( showTerms: showTerms, onLicenseDeclined: onLicenseDeclined )
                    .padding(.top, 48)
            }
            .asCard()
            .padding(.top, 16)
        }
    }
}
