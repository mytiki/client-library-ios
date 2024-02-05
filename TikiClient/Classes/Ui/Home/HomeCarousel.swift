/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI
import Foundation

public struct HomeCarousel : View {
    
    let providers: [AccountProvider]
    let onProvider: (AccountProvider) ->  Void


    public var body: some View {
        ScrollView (.horizontal, showsIndicators: false){
            HStack(spacing: 20) {
                    ForEach(providers, id: \.hashValue){ provider in
                        HomeProvider(provider: provider, status: .unverified)
                            .onTapGesture {
                                print(provider)
                                onProvider(provider)
                        }
                    }
                }
        }.frame(width: 390, height: 120)
    }
}
