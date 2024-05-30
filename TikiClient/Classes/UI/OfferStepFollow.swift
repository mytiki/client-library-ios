/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

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
