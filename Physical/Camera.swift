import SwiftUI
import PhotosUI

public struct CameraView: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    public init() {
        
    }
    public var body: some View {
        VStack {
            if let selectedImage{
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Button("Open camera") {
                self.showCamera.toggle()
            }
            .fullScreenCover(isPresented: self.$showCamera) {
                accessCameraView(selectedImage: self.$selectedImage)
            }
        }
    }
}

public struct accessCameraView: UIViewControllerRepresentable {
    
    @Binding public var selectedImage: UIImage?
    @Environment(\.presentationMode) public var isPresented

    
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}


