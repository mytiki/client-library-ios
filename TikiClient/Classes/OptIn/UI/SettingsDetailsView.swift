/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */
import Foundation
import SwiftUI

struct SettingsDetailView: View {
    let offer: Offer
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack {
                    Text(offer.description ?? "description")
                        .font(.largeTitle)
                        .padding(.bottom, 10)
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus quis massa et eros volutpat posuere a vel nisl.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                    if(offer.mutable){
                        Button("Edit Offer") {
                            print("Edit Offer")
                        }

                    }
                    Spacer()
                }
            }
            .navigationTitle(offer.id)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
