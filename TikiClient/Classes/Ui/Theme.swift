import SwiftUI

/// Custom theme definition.
public class Theme {
    var _primaryTextColor = Color.tikiBlack
    var _secondaryTextColor = Color.tikiDarkGray
    var _primaryBackgroundColor = Color.tikiWhite
    var _secondaryBackgroundColor = Color.tikiLightGray
    var _accentColor = Color.tikiGreen
    var _fontFamily = "SpaceGrotesk-Light"
    
    init(primaryTextColor: Color = Color.tikiBlack, secondaryTextColor: Color = Color.tikiDarkGray, primaryBackgroundColor: Color = Color.tikiWhite, secondaryBackgroundColor: Color = Color.tikiLightGray, accentColor: Color = Color.tikiGreen, fontFamily: String = "SpaceGrotesk-Light") {
        self._primaryTextColor = primaryTextColor
        self._secondaryTextColor = secondaryTextColor
        self._primaryBackgroundColor = primaryBackgroundColor
        self._secondaryBackgroundColor = secondaryBackgroundColor
        self._accentColor = accentColor
        self._fontFamily = fontFamily
        if(self._fontFamily == "SpaceGrotesk-Light"){
            Font.registerSpaceGrotesk()
        }
    }
    
    /// Theme font light
    public func fontLight(size: CGFloat) -> Font {
        return Font.custom("\(_fontFamily)", size: size)
    }
    
    /// Theme font regular
    public func fontRegular(size: CGFloat) -> Font {
        return Font.custom("\(_fontFamily)_Regular", size: size)
    }
    
    /// Theme font medium
    public func fontMedium(size: CGFloat) -> Font {
        return Font.custom("\(_fontFamily)_Medium", size: size)
    }
    
    /// Theme font bold
    public func fontBold(size: CGFloat) -> Font {
        return Font.custom("\(_fontFamily)_Bold", size: size)
    }
    
    /// Primary text color. Used in the default text items.
    public var primaryTextColor: Color { _primaryTextColor }
    
    /// Secondary text color. Used in specific text items.
    ///
    /// Defaults to [primaryTextColor] with 60% alpha transparency.
    public var secondaryTextColor: Color { _secondaryTextColor }
    
    /// Primary background color. The default color for backgrounds.
    public var primaryBackgroundColor: Color { _primaryBackgroundColor }
    
    /// Secondary background color.
    public var secondaryBackgroundColor: Color { _secondaryBackgroundColor }
    
    /// Accent color. Used to decorate or highlight items.
    public var accentColor: Color { _accentColor }
    
    public func primaryTextColor(_ primaryTextColor: Color) -> Self {
        self._primaryTextColor = primaryTextColor
        return self
    }
    
    public func secondaryTextColor(_ secondaryTextColor: Color) -> Self {
        self._secondaryTextColor = secondaryTextColor
        return self
    }
    
    public func primaryBackgroundColor(_ primaryBackgroundColor: Color) -> Self {
        self._primaryBackgroundColor = primaryBackgroundColor
        return self
    }
    
    public func secondaryBackgroundColor(_ secondaryBackgroundColor: Color) -> Self {
        self._secondaryBackgroundColor = secondaryBackgroundColor
        return self
    }
    
    public func accentColor(_ accentColor: Color) -> Self {
        self._accentColor = accentColor
        return self
    }
    
    public func fontFamily(_ fontFamily: String) -> Self {
        self._fontFamily = fontFamily
        return self
    }
}
