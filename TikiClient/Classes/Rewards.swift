//
//  Rewards.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 14/05/24.
//

import Foundation

public class Rewards {
    let virtualCurrency: String
    let exclusiveAccess: String
    let upgrades: String
    let custom: String
    
    public init(virtualCurrency: String, exclusiveAccess: String, upgrades: String, custom: String) {
        self.virtualCurrency = virtualCurrency
        self.exclusiveAccess = exclusiveAccess
        self.upgrades = upgrades
        self.custom = custom
    }
}
