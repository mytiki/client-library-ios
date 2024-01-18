import Foundation

/// Data structure representing an earned reward.
public struct Reward {

    /// Merchant ID.
    public let merchantId: String

    /// Merchant name.
    public let merchantName: String

    /// Commission earned.
    public let commission: Double

    /// Initializes a new instance of `Reward`.
    ///
    /// - Parameters:
    ///   - merchantId: Merchant ID.
    ///   - merchantName: Merchant name.
    ///   - commission: Commission earned.
    public init(merchantId: String, merchantName: String, commission: Double) {
        self.merchantId = merchantId
        self.merchantName = merchantName
        self.commission = commission
    }
}
