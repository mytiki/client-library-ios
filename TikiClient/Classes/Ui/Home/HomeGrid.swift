/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import SwiftUI

public struct HomeGrid: View{
    
    @Binding var isOpen: Bool
    var providers: [AccountProvider]
    let onProvider: (AccountProvider) ->  Void


    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    public var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 0){
                LazyVGrid(columns: gridItemLayout, spacing: 24) {
                    ForEach(providers, id: \.hashValue){ provider in
                        HomeProvider(provider: provider, status: .unverified)
                            .onTapGesture {
                                onProvider(provider)
                        }
                    }
                }
            }.padding(.horizontal, 24)
            .frame(maxHeight: .infinity)
        }.refreshable {
            isOpen = false
        }
    }
}
