import Foundation
import SwiftSoup
import SwiftUI

enum APIError: Error {
    case unauthorized
    case notFound
    case serverError
    case unknownError(String)
    case decodingError(Error)
    case other(Error)
}

enum Purity: String, CaseIterable, Hashable, Identifiable {
    var id : String { UUID().uuidString }
    case sfw
    case sketchy
    case nsfw
}

enum Category: String, CaseIterable, Hashable, Identifiable {
    var id: String { UUID().uuidString }
    case general
    case anime
    case people
}

enum Sorting: String, CaseIterable, Hashable, Identifiable  {
    var id: String { UUID().uuidString }
    case dateAdded = "date_added"
    case relevance
    case random
    case views
    case favorites
    case toplist
}

enum Order: String, CaseIterable, Hashable, Identifiable {
    var id: String { UUID().uuidString }
    case desc
    case asc
}

enum TopRange: String ,CaseIterable, Hashable, Identifiable {
    var id: String { UUID().uuidString }
    case oneDay = "1d"
    case threeDays = "3d"
    case oneWeek = "1w"
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1y"
}

enum TagResultTypes {
    case popular
    case viewed
}

struct Tag {
    let id = UUID()
    let tagName: String
}

struct APIService {
    
    func getWallpapers(configs: WallpaperConfigs = WallpaperConfigs(), apiKey: String? = nil) async -> [Wallpaper] {
        var wallpapers = [Wallpaper]()
        
        do {
            let url = generateURL(configs: configs, apiKey: apiKey)
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WallpaperResponse.self, from: data)
            wallpapers = response.data
        } catch {
            print(error)
        }
        return wallpapers
    }
    
    func getSearchedWallpapers(searchTerm: String) async -> [Wallpaper] {
        var wallpapers = [Wallpaper]()
        do {
            let url = URL(string: Constants.WallHavenURL.search())!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WallpaperResponse.self, from: data)
            wallpapers = response.data
        } catch {
            print(error)
        }
        
        return wallpapers
    }
    
    func getTags(tagType: TagResultTypes) async -> [Tag] {
        do {
            var url: URL
            
            if tagType == .popular {
                url = URL(string: Constants.WallHavenURL.popularTags())!
            } else {
                url = URL(string: Constants.WallHavenURL.viewedTags())!
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            if let htmlString = String(data: data, encoding: .utf8) {
                let tags = self.parseHTML(htmlString)
                if !tags.isEmpty {
                    return tags
                }
            }
        } catch {
            print(error)
        }
        
        return []
    }

    
    
    
    private func parseHTML(_ html: String) -> [Tag] {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let elements: Elements = try doc.select("span.taglist-name a")

            var extractedTags = [Tag]()
            for element in elements.array() {
                let tagText = try element.text()
                let newTag = Tag(tagName: tagText)
                extractedTags.append(newTag)
            }

            return extractedTags
        } catch Exception.Error(let type, let message) {
            print("Error type: \(type), Message: \(message)")
        } catch {
            print("error")
        }
        return []
    }
    
    func verifyAPIKey(withKey apiKey: String) async -> Result<Void, Error> {
        do {
            let url = URL(string: Constants.WallHavenURL.search())!.appending("apikey", value: apiKey)
            let (_, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code is: \(httpResponse.statusCode)")
                let statusCode = httpResponse.statusCode
                if statusCode == 401 {
                    throw APIError.unauthorized
                }
            }
        } catch {
            return .failure(APIError.other(error))
        }
        return .success(())
    }
    
    private func generateSeed() -> String {
        var seed = ""
        
        let seedLength = 6
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for _ in 0 ..< seedLength {
            seed.append(characters.randomElement()!)
        }
        return seed
    }
    
    private func generateURL(configs: WallpaperConfigs, apiKey: String? = nil) -> URL {
        
        var url = URL(string: Constants.WallHavenURL.search())!
            .appending("seed", value: generateSeed())
            .appending("sorting", value: configs.sorting.rawValue)
            .appending("categories", value: configs.getCategoryString())
            .appending("purity", value: configs.getPurityString())
            .appending("topRange", value: configs.topRange.rawValue)
        
        if let page = configs.page {
            url = url.appending("page", value: String(page))
        }
        
        if let query = configs.query {
            url = url.appending("q", value: query)
        }
        print("URL is \(url.absoluteString)")
        return url
    }
    
    
    func loadImageFromURL(wallpaperURL: String) async -> Image? {
        guard let url = URL(string: wallpaperURL) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage.resized(toWidth: 800.0)!)
            }
        } catch { }
        return nil
    }
    
}
