/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct ScreenHeader: View{
    
    let title: String
    let action: () -> Void

    public var body: some View {
        HStack{
            Image(systemName: "arrow.backward")
                .onTapGesture {
                    action()
                }
            Text(title.uppercased()).font(Rewards.theme.fontBold(size: 20))
          Spacer()
        }.padding(.horizontal, 15)
    }
}
