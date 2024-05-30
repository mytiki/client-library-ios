//
//  SettingsView.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 30/05/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
  let offer: Offer

  var body: some View {
    NavigationLink(destination: SettingsDetailView(offer: offer)) {
      HStack {
        Text(offer.description ?? "description")
          .font(.headline)
          .lineLimit(1)
        Spacer()
      }
      .padding(.vertical, 8)
    }
  }
}
