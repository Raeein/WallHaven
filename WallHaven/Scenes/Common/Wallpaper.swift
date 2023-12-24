import SwiftUI

protocol ImageSource {
    func getImageData() -> ImageData
}

struct ImageData {
    var id: String
    var imageURL: String?
    var localImageName: String?
}


struct WallpaperResponse: Codable {
    let data: [Wallpaper]
}

struct Wallpaper: Codable, Hashable {

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.id == rhs.id
    }

    let id: String
    let url: String
    let shortUrl: String
    let views: Int
    let favorites: Int
    let source: String
    let purity: String
    let category: String
    let dimensionX: Int
    let dimensionY: Int
    let resolution: String
    let ratio: String
    let fileSize: Int
    let fileType: String
    let createdAt: String
    let colors: [String]
    let path: String
    let thumbs: Thumbs

    private enum CodingKeys: String, CodingKey, Hashable {
        case id, url, shortUrl = "short_url", views, favorites, source, purity, category
        case dimensionX = "dimension_x", dimensionY = "dimension_y", resolution, ratio
        case fileSize = "file_size", fileType = "file_type", createdAt = "created_at", colors, path, thumbs
    }
}

struct Thumbs: Codable, Hashable {
    let large: String
    let original: String
    let small: String
}

struct TagSearch: Codable, Hashable {
    let id: Int
    let tag: String
}

//MARK: - Helper functions
extension Wallpaper {
    
    func formatNumber(_ number: Int) -> String {
        let num = Double(number)
        let thousand = num / 1000
        let million = num / 1_000_000

        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        } else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        } else {
            return "\(number)"
        }
    }

    
    func getViews() -> String {
        return formatNumber(views)
    }

    func getFavorites() -> String {
        return formatNumber(favorites)
    }

    func getFileSize() -> String {
        let fileSizeInMB = Double(fileSize) / 1_048_576 // Convert bytes to megabytes
        return String(format: "%.2f MB", fileSizeInMB)
    }
}

extension Wallpaper: ImageSource {

    func getImageData() -> ImageData {
        return ImageData(id: self.id, imageURL: self.path, localImageName: nil)
    }
}
