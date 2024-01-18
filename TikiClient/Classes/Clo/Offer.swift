import Foundation

/// Data structure representing an offer.
public struct Offer {

    /// Offer banner image URL.
    public let bannerUrl: String

    /// The description of the offer.
    public let description: String

    /// The URL of the offer.
    public let clickUrl: String

    /// Commission type.
    public let commissionType: ComissionEnum

    /// Commission in cents.
    public let totalCommission: Double

    /// Initializes a new instance of `Offer`.
    ///
    /// - Parameters:
    ///   - bannerUrl: Offer banner image URL.
    ///   - description: The description of the offer.
    ///   - clickUrl: The URL of the offer.
    ///   - commissionType: Commission type.
    ///   - totalCommission: Commission in cents.
    public init(bannerUrl: String, description: String, clickUrl: String, commissionType: ComissionEnum, totalCommission: Double) {
        self.bannerUrl = bannerUrl
        self.description = description
        self.clickUrl = clickUrl
        self.commissionType = commissionType
        self.totalCommission = totalCommission
    }
}
