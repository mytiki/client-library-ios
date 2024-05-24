//
//  OfferStepFollow.swift
//  TikiClient
//
//  Created by Jesse Monteiro Ferreira on 24/05/24.
//

import Foundation


public class OfferStepFollow: ObservableObject {
    public var offerFollowSteps: OfferFlowStep {
        willSet {
            objectWillChange.send()
        }
    }
    public init(offerFollowSteps: OfferFlowStep) {
        self.offerFollowSteps = offerFollowSteps
    }
}
