import UIKit

/// Service for capturing and processing receipt data.
public class CaptureService: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePickerCallback: ((UIImage) -> Void)? = nil
    var imagePickerRootVc: UIViewController? = nil

    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image.
    public func scan(onFinish: @escaping (UIImage) -> Void){
      imagePickerCallback = onFinish
      let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
      imagePickerRootVc = keyWindow?.rootViewController
      let imagePickerController = UIImagePickerController()
      imagePickerController.allowsEditing = false
      imagePickerController.sourceType = .camera
      imagePickerController.delegate = self
      imagePickerRootVc?.present(imagePickerController, animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePickerCallback?(tempImage);
        imagePickerRootVc?.dismiss(animated: true, completion: nil)
        imagePickerCallback = nil
        imagePickerRootVc = nil
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

