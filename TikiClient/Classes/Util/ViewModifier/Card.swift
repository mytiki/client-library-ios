/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */
 
import SwiftUI

public struct Card: ViewModifier {

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white)
            .shadow(color: Rewards.theme.secondaryBackgroundColor, radius: 0, x: 4, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Rewards.theme.secondaryTextColor))
            )
    }
}

extension View {
    func asCard() -> some View {
        modifier(Card())
    }

}
