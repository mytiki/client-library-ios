//
//  OfferView.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 21/05/24.
//

import SwiftUI

public struct OfferView: View {
    public init() {}
    public var body: some View {
        Color.green
            .ignoresSafeArea() // Ignore just for the color
            .overlay(
                VStack(alignment: .leading, spacing: 20) {
                    Text("Share your purchase history:").font(.largeTitle).foregroundColor(.white)
                    Text("We use your data for:").font(.headline).foregroundColor(.white)
                    Text("Aggregate market insights").font(.subheadline).foregroundColor(.white)
                    Text("Exclusive offers just for you").font(.subheadline).foregroundColor(.white)
                    Text("Improving systems like AI").font(.subheadline).foregroundColor(.white)
                    Text("Learn more or change your mind any time in settings.").font(.headline).foregroundColor(.white)
                    Button() {
                        print("Linked card")
                    } label: {
                        Text("Link Card")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.green)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(50)
                    }.buttonStyle(.plain)
                    Button() {
                        print("No Thanks")
                    } label: {
                        Text("No Thanks")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color(.green))
                            .cornerRadius(50)
                            
                    }.buttonStyle(.plain)
                }.padding(.horizontal, 40)
            )
    }
}
