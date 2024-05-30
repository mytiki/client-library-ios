import SwiftUI

public struct OfferFlow: View{
    @ObservedObject public static var step = OfferStepFollow(offerFollowSteps: .permissions)
    public init() {}
    
    public var body: some View{
        switch(OfferFlow.step.offerFollowSteps){
        case .permissions:
            OfferAllowTrackView()
        case .offers:
            OfferLinkCardView()
        case .settings:
            OfferLinkCardView()
        }
    }

    
}
