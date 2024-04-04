/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */

/// Service for capturing and processing receipt data.
public class CaptureService {
    
    var captureScan = CaptureScan()

    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image.
    public func scan(onFinish: @escaping (UIImage) -> Void){
        captureScan.captureScan(onFinish: onFinish)
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
    
}

