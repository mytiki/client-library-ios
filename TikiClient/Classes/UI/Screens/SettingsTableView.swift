//
//  SettingsView.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 30/05/24.
//

import Foundation
import SwiftUI

public struct SettingsTableView: View {
  @State private var offersList = [
    Offer(_id: "11", ptr: "111", description: "Offer 1", terms: "terms", reward: [Reward(decription: "Reward 1", type: .init(virtualCurrency: "USD", exclusiveAccess: "no", upgrades: "", custom: ""), amount: "10")] , use: Use(usecases: [Usecase(usecase: .aiTraining)]), tags: [Tag(tag: .HEALTH)], permissions: [Permission.locationAlways], mutable: true),
    Offer(_id: "22", ptr: "222", description: "Offer 2", terms: "terms", reward: [Reward(decription: "Reward 2", type: .init(virtualCurrency: "USD", exclusiveAccess: "no", upgrades: "", custom: ""), amount: "10")] , use: Use(usecases: [Usecase(usecase: .aiTraining)]), tags: [Tag(tag: .HEALTH)], permissions: [Permission.locationAlways], mutable: false),
    Offer(_id: "33", ptr: "333", description: "Offer 3", terms: "terms", reward: [Reward(decription: "Reward 2", type: .init(virtualCurrency: "USD", exclusiveAccess: "no", upgrades: "", custom: ""), amount: "10")] , use: Use(usecases: [Usecase(usecase: .aiTraining)]), tags: [Tag(tag: .HEALTH)], permissions: [Permission.locationAlways], mutable: false)
  ]

    public var body: some View {
    List {
      ForEach(offersList) { offer in
          SettingsView(offer: offer)      
      }
      .onDelete { indexSet in
        offersList.remove(atOffsets: indexSet)
      }
      .onMove { indices, newOffset in
        offersList.move(fromOffsets: indices, toOffset: newOffset)
      }
    }
    .navigationTitle("Settings")
    .navigationBarItems(trailing: EditButton())
  }
}
