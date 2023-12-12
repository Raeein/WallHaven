import Foundation

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
