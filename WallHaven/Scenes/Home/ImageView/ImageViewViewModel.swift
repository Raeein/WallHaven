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
    #if os(iOS)
    @Published var originalUIImage: UIImage?
    @Published var filteredUIImage: UIImage?
    #endif
    #if os(macOS)
    @Published var originalNSImage: NSImage?
    @Published var filteredNSImage: NSImage?
    #endif
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

    
    #if os(iOS)
    func setAverageColor() {
        guard let originalUIImage else { return }
        let uiColor = originalUIImage.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }
    
    func saveImage() {
        guard let imageToSave = filteredUIImage ?? originalUIImage else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: imageToSave)
        withAnimation {
            showToast = true
            imageSaved.toggle()
        }
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
    #endif

    #if os(macOS)
    @MainActor func applyBlueFilter(image: Image, radius: Float) {
        guard radius != 0.0 else {
            filteredImage = nil
            filteredNSImage = nil
            return
        }
        if originalNSImage == nil {
            originalNSImage = image.getNSImage()
        }
        let cgImage = originalNSImage!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let beginImage = CIImage(cgImage: cgImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.gaussianBlur()
        
        currentFilter.inputImage = beginImage
        currentFilter.radius = radius
        
        guard let outputImage = currentFilter.outputImage else { return }

        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let size = NSSize(width: cgImage.width, height: cgImage.height)
        let nsImage = NSImage(cgImage: cgImage, size: size)

        filteredImage = Image(nsImage: nsImage)
        filteredNSImage = filteredImage?.getNSImage()
    }
    func setAverageColor() {
        guard let originalNSImage else { return }
        let nsColor = originalNSImage.averageColor ?? .clear
        backgroundColor = Color(nsColor)
    }
    func openPrivacySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy") {
                NSWorkspace.shared.open(url)
            }
    }
    
    #endif
    
    
    func saveImage() {
        guard let imageToSave = filteredNSImage ?? originalNSImage else { return }
        let imageSaver = ImageSaver()
        #if os(iOS)
        imageSaver.writeToPhotoAlbum(image: imageToSave)
        #endif
        
        #if os(macOS)
        if let url = imageSaver.showSavePanel() {
            imageSaver.saveImage(image: imageToSave, path: url)
        }
        #endif
        
        withAnimation {
            showToast = true
            imageSaved.toggle()
        }
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

