import SwiftUI

struct LocalImage {
    let id = UUID()
    var imageName: String
    
    static func getSampleImages() -> [Image] {
        return [
            Image("SampleWallpaper1", bundle: .main),
            Image("SampleWallpaper2", bundle: .main),
            Image("SampleWallpaper3", bundle: .main),
        ]
    }
}

extension LocalImage: ImageSource {
    func getImageData() -> ImageData {
        return ImageData(id: self.id.uuidString, imageURL: nil, localImageName: self.imageName)
    }
}
