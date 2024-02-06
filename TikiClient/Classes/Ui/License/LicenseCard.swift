/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct LicenseCard: View{
    
    var estimate = Rewards.license.estimate()
    public var body: some View {
        VStack{
            Text("Earn monthly")
                .font(Rewards.theme.fontMedium(size: 20))
                .foregroundColor(.tikiBlack)
            Text("$5 - $15")
                .font(Rewards.theme.fontBold(size: 42))
                .foregroundColor(.tikiGreen)
            Text("for your shopping habits")
                .font(Rewards.theme.fontMedium(size: 20))
                .foregroundColor(.tikiBlack)
        }.padding(.vertical, 48).asCard()
    }
    
}
