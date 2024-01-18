import Foundation

/// Service for managing email accounts.
public class EmailService {

    /// Authenticates with OAuth and adds an email account for scraping receipts.
    ///
    /// - Parameter provider: The email provider (GOOGLE or OUTLOOK).
    public func login(provider: EmailProviderEnum) {
        // Implementation
    }

    /// Retrieves the list of connected email accounts.
    ///
    /// - Returns: List of connected email accounts.
    public func accounts() -> [String] {
        return []
    }

    /// Removes a previously added email account.
    ///
    /// - Parameter email: The email account to be removed.
    public func logout(email: String) {
        // Implementation
    }
}
