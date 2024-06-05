/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import Foundation


public class OptInService {
    public static var offer: Offer?
    public static var step: OfferFlowStep?
    public static var offerList: [Offer]?
    
    public static func showOffer(offer: Offer){
        OptInService.step = .offers
        for permission in offer.permissions {
            if(!(permission?.isAuthorized())!){
                OptInService.step = .permissions
                permission?.requestAuth()
            }
        }
        OptInService.offer = offer
    }
    
    public static func showSettings(offers: [Offer]){
        OptInService.step = .settings
        OptInService.offerList = offers
    }
}
