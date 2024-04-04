
/// Service for capturing and processing receipt data.
public class CaptureService {
    
    var captureScan = CaptureScan()

    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image.
    public func scan(onFinish: @escaping (UIImage) -> Void){
        captureScan.captureScan(onFinish: onFinish)
    }

    
}
