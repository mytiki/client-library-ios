/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI
import Foundation

public struct AccountIcon : View {
    public let provider: AccountProvider
    public let status: AccountStatus
    public var width: CGFloat?
    public var height: CGFloat?

    public var body: some View {
        ZStack() {
            TikiImages.from(provider.name())
                .resizable()
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Rewards.theme.secondaryBackgroundColor, radius: 0, x: 2, y: 2)
            switch status {
                case .unverified:
                    TikiImages.icAdd
                        .resizable()
                        .frame(width: 32, height: 32)
                default :
                    EmptyView()
            }
        }
    }
}
