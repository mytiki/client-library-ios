/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import Foundation
import SwiftUI

public struct TikiImages{
    public static let google = Image(uiImage: icon(icon: "google"))
    public static let googleAuth = Image(uiImage: icon(icon: "google_auth"))
    public static let gmail = Image(uiImage: icon(icon: "gmail"))
    public static let UberEats = Image(uiImage: icon(icon: "Uber Eats"))
    public static let DollarGeneral = Image(uiImage: icon(icon: "Dollar General"))
    public static let TacoBell = Image(uiImage: icon(icon: "Taco Bell"))
    public static let Walmart = Image(uiImage: icon(icon: "Walmart"))
    public static let minus = Image(uiImage: icon(icon: "minus"))
    public static let arrow_right = Image(uiImage: icon(icon: "arrowRight"))
    public static let purchases = Image(uiImage: icon(icon: "purchases"))
    public static let receipts = Image(uiImage: icon(icon: "receipts"))
    public static let userId = Image(uiImage: icon(icon: "userId"))
    public static let dollar = Image(uiImage: icon(icon: "dollar"))
    public static let discount = Image(uiImage: icon(icon: "discount"))
    public static let graphic = Image(uiImage: icon(icon: "graphic"))
    public static let grayAlert = Image(uiImage: icon(icon: "grayAlert"))
    public static let handStop = Image(uiImage: icon(icon: "handStop"))
    public static let redStop = Image(uiImage: icon(icon: "redStop"))
    public static let icAdd = Image(uiImage: icon(icon: "ic_add"))
    public static let icAlert = Image(uiImage: icon(icon: "ic_alert"))
    public static let sync = Image(uiImage: icon(icon: "sync"))
    public static let none = Image(uiImage: icon(icon: "gmail"))
    
    
    
    public static func from(_ from: String) -> Image {
        return  Image(uiImage: icon(icon: from.lowercased().replacingOccurrences(of: " ", with: "-")))
    }
}

private func icon(icon: String) -> UIImage{

    let bundle = Bundle(for: Rewards.self)
    let resourceBundle = Bundle(url: bundle.url(forResource: "RewardsAssets", withExtension: "bundle")!)!
    if(icon == "none" || icon == "custom"){
        return UIImage(named: "Assets/icons/\("google")", in: resourceBundle, compatibleWith: nil)!
    }else{
        let icon = UIImage(named: "Assets/icons/\(icon)", in: resourceBundle, compatibleWith: nil)
        return icon!
    }
}
