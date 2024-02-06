/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */
 
import SwiftUI

public struct Screen: ViewModifier {
    
    let title: String
    let action: () -> Void

    public func body(content: Content) -> some View {
        ScrollView() {
            VStack(alignment: .leading, spacing: 0){
                ScreenHeader(title: title, action: action)
                VStack(alignment: .leading, spacing: 0){
                    content
                }
                .padding(.horizontal, 21)
            }
            .padding(.bottom, 56)
        }
        .padding(.top, 1 )
            .background(.white)
        
    }
}

extension View {
    func asScreen(title: String, action: @escaping () -> Void) -> some View {
        modifier(Screen(title: title, action: action))
    }

}
