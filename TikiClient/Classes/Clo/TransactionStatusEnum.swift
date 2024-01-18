import Foundation

/// Enum representing the status of a transaction.
@available(iOS 15.0, *)
public enum TransactionStatusEnum: String {
    /// Approved status.
    case approved = "APPROVED"
    
    /// Settled status.
    case settled = "SETTLED"
    
    /// Reversed status.
    case reversed = "REVERSED"
    
    /// Declined status.
    case declined = "DECLINED"
    
    /// Returned status.
    case returned = "RETURNED"
}
