import SwiftUI

public struct OfferFlow: View{
    @ObservedObject public static var step = OfferStepFollow(offerFollowSteps: .settings)
    public init() {}
    
    public var body: some View{
        switch(OfferFlow.step.offerFollowSteps){
        case .permissions:
            OfferAllowTrackView()
        case .offers:
            OfferLinkCardView()
        case .settings:
            NavigationView{
                SettingsTableView()
            }
        }
    }

    
}
