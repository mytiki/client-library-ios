import Foundation

/// Enum representing the types of commission.
@available(iOS 15.0, *)
public enum ComissionEnum: String {
    /// Percent of the purchase.
    case percent = "PERCENT"
    
    /// Fixed value.
    case flat = "FLAT"
}
