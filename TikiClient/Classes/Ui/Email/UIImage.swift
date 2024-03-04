extension UIImage {
    convenience init?(base64: String){
        guard let imageData = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
              return nil
          }
          self.init(data: imageData)
  }
}
