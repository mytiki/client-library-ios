
import Foundation

/// Tiki Client Library
///
/// The TIKI APIs comprise a set of HTTP REST APIs designed for seamless integration with any
/// standard HTTP client. The Client Libraries serve as a user-friendly layer around the TIKI APIs,
/// introducing methods for common operations such as authorization, licensing, capture, card-linked
/// offers, and rewards. It is a collection of pre-existing code with minimal dependencies, offering
/// a streamlined integration process with TIKI Rest APIs, which reduces the amount of code necessary
/// for integration.
///
/// `TikiClient` is the top-level entry point for the TIKI Client Library. It offers simple methods
/// that call the underlying libraries to perform common operations. Programmers can use it to
/// simplify the integration process or opt for individual libraries based on their specific needs.
public class TikiClient {
    
    public let auth = AuthService()
    public let capture = CaptureService()
    public let clo = CloService()
    public let email = EmailService()
    public let license = LicenseService()
    private let ui = UiService()

    /// Initializes the `TikiClient` with the application context and sets its parameters.
    /// - Parameters:
    ///   - context: The application context.
    ///   - providerId: The TIKI Publishing ID of the data provider.
    ///   - userId: The user identification from the provider.
    ///   - company: The legal information of the company.
    public func initialize(context: Context, providerId: String, userId: String, company: Company) {
        // Implementation
    }

    /// Initiates the process of scanning a physical receipt and returns the receipt ID.
    /// - Returns: The scanned receipt data or an empty string if the scan is unsuccessful.
    public func scan() -> String {
        return ""
    }

    /// Initiates the process of scraping receipts from emails.
    /// - Parameter emailProvider: The email provider (GOOGLE or OUTLOOK).
    public func login(emailProvider: EmailProviderEnum) {
        // Implementation
    }

    /// Removes a previously added email account.
    /// - Parameter email: The email account to be removed.
    public func logout(email: String) {
        // Implementation
    }

    /// Retrieves the list of connected email accounts.
    /// - Returns: List of connected email accounts.
    public func accounts() -> [String] {
        return []
    }

    /// Initiates the process of scraping receipts from emails.
    public func scrape() {
        // Implementation
    }

    /// Adds a card for card-linked offers.
    /// - Parameters:
    ///   - last4: Last 4 digits of the card.
    ///   - bin: Bank Identification Number.
    ///   - issuer: Card issuer.
    ///   - network: Card network (VISA, MASTERCARD, AMERICAN EXPRESS, or DISCOVERY).
    public func card(last4: String, bin: String, issuer: String, network: String) {
        // Implementation
    }

    /// Retrieves card-linked offers for the user.
    /// - Returns: List of card-linked offers.
    public func offers() -> [Offer] {
        return []
    }

    /// Submits a transaction for card-linked offer matching.
    /// - Parameter transaction: The transaction information.
    public func transaction(transaction: Transaction) {
        // Implementation
    }

    /// Retrieves information about the user's rewards.
    /// - Returns: List of user rewards.
    public func rewards() -> [Reward] {
        return []
    }

    /// Displays the widget for pre-built UIs with a custom theme.
    /// - Parameter theme: The custom theme for the widget.
    public func widget(theme: Theme?) {
        // Implementation
    }
}
```

Please note that the `@available(iOS 15.0, *)` attribute is used to indicate the minimum iOS version where the code is available. Adjust this according to your project's deployment target.
