/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

import SwiftUI

public struct SpaceGrotesk{
    public static func light(size: CGFloat) -> Font {
        return Font.custom("SpaceGrotesk-Light", size: size)
    }
    public static func regular(size: CGFloat) -> Font {
        return Font.custom("SpaceGrotesk-Light_Regular", size: size)
    }
    public static func medium(size: CGFloat) -> Font {
        return Font.custom("SpaceGrotesk-Light_Medium", size: size)
    }
    public static func bold(size: CGFloat) -> Font {
        return Font.custom("SpaceGrotesk-Light_Bold", size: size)
    }
}

extension Font {
    public static func registerSpaceGrotesk() {
        let bundle = Bundle(for: Rewards.self)
        let resourceBundle = Bundle(url: bundle.url(forResource: "RewardsAssets", withExtension: "bundle")!)!
        guard let fontURL = resourceBundle.url(forResource: "Assets/SpaceGrotesk", withExtension: "ttf") else {
            return 
//            fatalError("Couldn't find font SpaceGrotesk")
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        guard success else {
            print("Error registering font: maybe it was already registered.")
            return
        }
    }
}


