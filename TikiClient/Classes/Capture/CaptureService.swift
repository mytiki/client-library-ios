import UIKit

/// Service for capturing and processing receipt data.
public class CaptureService {

    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image.
    public func camera() -> UIImage? {
        return nil
    }

    /// Downloads potential receipt data from known receipt email senders and publishes it.
    ///
    /// - Parameter onPublish: The callback function to be called on each uploaded email.
    public func email(onPublish: @escaping (String) -> Void) {
        // Implementation
    }

    /// Uploads receipt images or email data for receipt data extraction.
    ///
    /// - Parameter data: The binary image or email data.
    /// - Returns: The ID of the uploaded data to check publishing status.
    public func publish(data: UIImage) -> String {
        return ""
    }

    /// Checks the publishing status of the data.
    ///
    /// - Parameter receiptId: The ID of the published data.
    /// - Returns: The publishing status.
    public func status(receiptId: String) -> PublishingStatusEnum {
        return .inProgress
    }
    
    
    /// Retrieves a list of retailer offers for a specific account provider.
    ///
    /// - Parameter provider: The account provider for which offers should be retrieved.
    /// - Returns: An array of `RetailerOffer` objects containing offer details.
    func offers(provider: AccountProvider) -> [RetailerOffer] {
        return [
            RetailerOffer(provider: provider, description: "4% cashback on electronics", url: URL(string: "https://mytiki.com")!),
            RetailerOffer(provider: provider, description: "10% off on electronics", url: URL(string: "https://mytiki.com")!)
        ]
    }
}

