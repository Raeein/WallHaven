
import SwiftUI

extension Image {
    #if os(iOS)
    @MainActor
    func getUIImage() -> UIImage? {
        return ImageRenderer(content: self).uiImage
    }
    #endif
    
    #if os(macOS)
    @MainActor
    func getNSImage() -> NSImage? {
        return ImageRenderer(content: self).nsImage
    }
    #endif
}

