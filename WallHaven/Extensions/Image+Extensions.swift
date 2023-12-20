import SwiftUI

extension Image {
    @MainActor
    func getUIImage() -> UIImage? {
        return ImageRenderer(content: self).uiImage
    }
}
