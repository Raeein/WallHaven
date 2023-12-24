#if os(iOS)
import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
#endif

#if os(macOS)
import AppKit
func showSavePanel() -> URL? {

     let savePanel = NSSavePanel()
     savePanel.allowedContentTypes = [.png]
     savePanel.canCreateDirectories = true
     savePanel.isExtensionHidden = false
     savePanel.title = "Save your image"
     savePanel.message = "Choose a folder and a name to store the image."
     savePanel.nameFieldLabel = "Image file name:"

     let response = savePanel.runModal()

     return response == .OK ? savePanel.url : nil

 }
func savePNG(imageName: String, path: URL) {

    let image = NSImage(named: imageName)!
    let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
    let pngData = imageRepresentation?.representation(using: .png, properties: [:])
    do {
        try pngData!.write(to: path)

    } catch {
        print(error)
    }
}
#endif
