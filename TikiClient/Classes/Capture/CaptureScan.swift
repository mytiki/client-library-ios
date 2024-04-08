/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in the root directory.
 */


import Foundation

public class CaptureScan: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePickerCallback: ((UIImage?) -> Void)? = nil
    var imagePickerRootVc: UIViewController? = nil

    /// Captures an image of a receipt for processing.
    ///
    /// - Returns: The captured receipt image.
    public func start(onFinish: @escaping (UIImage) -> Void){
      imagePickerCallback = onFinish
      let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
      imagePickerRootVc = keyWindow?.rootViewController
      let imagePickerController = UIImagePickerController()
      imagePickerController.allowsEditing = false
      imagePickerController.sourceType = .camera
      imagePickerController.delegate = self
      imagePickerRootVc?.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
          self.imagePickerCallback(image)
        }else{
          self.imagePickerCallback(nil)
        }
        cleanUp()
    }

    private func imagePickerControllerDidCancel(_: UIImagePickerController) {
        self.imagePickerCallback(nil)
        cleanUp()
    }

    private cleanUp(){
      imagePickerRootVc.dismiss()
      imagePickerCallback = nil
      imagePickerRootVc = nil
    }
}
