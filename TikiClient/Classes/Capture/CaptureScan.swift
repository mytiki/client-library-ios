/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public class CaptureScan: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePickerCallback: ((UIImage) -> Void)? = nil
    var imagePickerRootVc: UIViewController? = nil

    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image.
    public func captureScan(onFinish: @escaping (UIImage) -> Void){
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
}
