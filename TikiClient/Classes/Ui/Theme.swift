import SwiftUI

/// Custom theme definition.
public struct Theme {
    
    /// Default primary text color.
    public let primaryTextColor: Color
    
    /// Default secondary text color.
    public let secondaryTextColor: Color
    
    /// Default primary background color.
    public let primaryBackgroundColor: Color
    
    /// Default secondary background color.
    public let secondaryBackgroundColor: Color
    
    /// Default accent color.
    public let accentColor: Color
    
    /// Default font family.
    public let fontFamily: Font
    
    /// Initializes a new instance of `Theme`.
    ///
    /// - Parameters:
    ///   - primaryTextColor: Default primary text color.
    ///   - secondaryTextColor: Default secondary text color.
    ///   - primaryBackgroundColor: Default primary background color.
    ///   - secondaryBackgroundColor: Default secondary background color.
    ///   - accentColor: Default accent color.
    ///   - fontFamily: Default font family.
    public init(
        primaryTextColor: Color = Color(hex: 0xFF000000),
        secondaryTextColor: Color = Color(hex: 0x99000000),
        primaryBackgroundColor: Color = Color(hex: 0xFFFFFFFF),
        secondaryBackgroundColor: Color = Color(hex: 0x15000000),
        accentColor: Color = Color(hex: 0xFF00B272),
        fontFamily: Font = .custom("Space Grotesk", size: 17)
    ) {
        self.primaryTextColor = primaryTextColor
        self.secondaryTextColor = secondaryTextColor
        self.primaryBackgroundColor = primaryBackgroundColor
        self.secondaryBackgroundColor = secondaryBackgroundColor
        self.accentColor = accentColor
        self.fontFamily = fontFamily
    }
}
