import Foundation

/// Service for card-linked offers.
public class CloService {

    /// Adds a card to the user's account.
    ///
    /// - Parameters:
    ///   - last4: Last 4 digits of the card.
    ///   - bin: Bank Identification Number.
    ///   - issuer: Card issuer.
    ///   - network: Card network (VISA, MASTERCARD, AMERICAN EXPRESS, or DISCOVERY).
    public func card(last4: String, bin: String, issuer: String, network: String) {
        // Implementation
    }

    /// Retrieves card-linked offers for the user.
    ///
    /// - Returns: List of card-linked offers.
    public func offers() -> [Offer] {
        return []
    }

    /// Retrieves information about the user's rewards.
    ///
    /// - Returns: List of user rewards.
    public func rewards() -> [Reward] {
        return []
    }

    /// Sends transaction information to match card-linked offers.
    ///
    /// - Parameter transaction: The transaction information.
    public func transaction(transaction: Transaction) {
        // Implementation
    }
}
