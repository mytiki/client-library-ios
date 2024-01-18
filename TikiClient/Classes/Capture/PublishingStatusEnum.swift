import Foundation

/// Enum representing the status of data processing.
@available(iOS 15.0, *)
public enum PublishingStatusEnum: String {
    /// In-progress status.
    case inProgress = "IN_PROGRESS"
    
    /// Error status.
    case error = "ERROR"
    
    /// Done status.
    case done = "DONE"
}
