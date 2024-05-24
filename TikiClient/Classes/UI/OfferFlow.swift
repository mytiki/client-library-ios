import SwiftUI

public struct OfferFlow: View{
    @ObservedObject public static var step = OfferStepFollow(offerFollowSteps: .none)
    public init() {}
    
    public var body: some View{
        switch(OfferFlow.step.offerFollowSteps){
        case .none:
            OfferAllowTrackView()
        case .allowTrackAsk:
            OfferAllowTrackView()
        case .linkCard:
            OfferLinkCardView()
        case .deniedLinkCard:
            OfferLinkCardView()
        case .deniedTrack:
            OfferAllowTrackView()
        }
    }

    
}
