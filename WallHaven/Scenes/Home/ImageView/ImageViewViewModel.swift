import SwiftUI
import Photos

enum PreviewType {
    case lockScreen
    case homeScreen
}

class ImageViewViewModel: ObservableObject {

    @Published var originalImage: Image?
    @Published var filteredImage: Image?
    @Published var backgroundColor: Color = .black
    @Published var showToast = false
    @Published var showAlert = false
    
    @Published var originalUIImage: UIImage?
    @Published var filteredUIImage: UIImage?
    @Published var showInfo = false
    @Published var imageSaved = false
    @Published var showBlurSlider = false
    @Published var blurValue: Double = 0
    @Published var isEditingSlider = false
    @Published var showPreviews = false
    @Published var showLockScreen = false
    @Published var showHomeScreen = false
    @Published var viewOpacity = 0.0
    @Published var previewType: PreviewType?

    func saveImage() {
        guard let imageToSave = filteredUIImage ?? originalUIImage else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: imageToSave)
        showToast = true
    }

    func loadImageFromURL(wallpaperURL: String) {
        guard let url = URL(string: wallpaperURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.originalImage = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }
    
    func setAverageColor() {
        guard let originalUIImage else { return }
        let uiColor = originalUIImage.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }
    
    @MainActor func applyBlueFilter(image: Image, radius: Float) {
        guard radius != 0.0 else {
            filteredImage = nil
            filteredUIImage = nil
            return
        }
        if originalUIImage == nil {
            originalUIImage = image.getUIImage()
        }
        let beginImage = CIImage(image: originalUIImage!)
        
        let context = CIContext()
        let currentFilter = CIFilter.gaussianBlur()
        
        currentFilter.inputImage = beginImage
        currentFilter.radius = radius
        
        guard let outputImage = currentFilter.outputImage else { return }

        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)

        filteredImage = Image(uiImage: uiImage)
        filteredUIImage = filteredImage?.getUIImage()
    }

    func openPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func saveImage(imageToSave: UIImage) {
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: imageToSave)
    }

    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case .restricted, .denied:
            completion(false)
        case .authorized, .limited:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
}

