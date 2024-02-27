extension UIImage {
  init(base64: String){
    guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
          return nil
      }
      return super.init(data: imageData)
  }
}