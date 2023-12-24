import Foundation
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

enum Sorting: String {
    case dateAdded = "date_added"
    case relevance
    case random
    case views
    case favorites
    case toplist
}

enum Order: String {
    case desc
    case asc
}

enum TopRange: String {
    case oneDay = "1d"
    case threeDays = "3d"
    case oneWeek = "1w"
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1y"
}

class WallpaperConfigs: ObservableObject {
    @Published var page: Int? = nil
    @Published var query: String? = nil
    @Published var topRange: TopRange = .oneYear
    @Published var sorting: Sorting = .random
    @Published var order: Order = .desc
    @Published var categories = [Category]()
    @Published var purities = [Purity]()
    
    let apiKey: String? = nil
    let isSearchView: Bool = false
    
    func addCategory(of newCategory: Category) {

        if !categories.contains(newCategory) {
            categories.append(newCategory)
        }
    }
    
    func getCategoryString() -> String {
        guard !categories.isEmpty else { return "000" }
        var result = ""
        
        result.append(categories.contains(.general) ? "1" : "0")
        result.append(categories.contains(.anime) ? "1" : "0")
        result.append(categories.contains(.people) ? "1" : "0")
        
        return result
    }
    
    func getPurityString() -> String {
        guard !purities.isEmpty else { return "000" }
        var result = ""
        
        result.append(purities.contains(.sfw) ? "1" : "0")
        result.append(purities.contains(.sketchy) ? "1" : "0")
        result.append(purities.contains(.nsfw) ? "1" : "0")
        
        return result
    }
    
    func getConfigsDescription() -> String {
       
        var description = "Configurations:\n"

        let purityString = getPurityString()
        description += "Purities: \(purityString)\n"

        let categoryString = getCategoryString()
        description += "Categories: \(categoryString)\n"

        description += "Sorting: \(sorting.rawValue), Order: \(order.rawValue)\n"

        if let query = query, !query.isEmpty {
            description += "Query: \(query)\n"
        }

        if let page = page {
            description += "Page: \(page)\n"
        }
        return description
    }
    
    func addPurity(of newPurity: Purity) {

        if !purities.contains(newPurity) {
            purities.append(newPurity)
        }
    }
    
    func isSFWSelected() -> Bool {
        return purities.contains(.sfw)
    }
    
    func isNSFWSelected() -> Bool {
        return purities.contains(.nsfw)
    }
    
    func isSketchySelected() -> Bool {
        return purities.contains(.sketchy)
    }
    
    func isPeopleSelected() -> Bool {
        return categories.contains(.people)
    }
    
    func isGeneralSelected() -> Bool {
        return categories.contains(.general)
    }
    
    func isAnimeSelected() -> Bool {
        return categories.contains(.anime)
    }
    
    func setSFWSelected(_ isSelected: Bool) {
         updatePurity(.sfw, isSelected: isSelected)
     }

     func setNSFWSelected(_ isSelected: Bool) {
         updatePurity(.nsfw, isSelected: isSelected)
     }

     func setSketchySelected(_ isSelected: Bool) {
         updatePurity(.sketchy, isSelected: isSelected)
     }

     func setPeopleSelected(_ isSelected: Bool) {
         updateCategory(.people, isSelected: isSelected)
     }

     func setGeneralSelected(_ isSelected: Bool) {
         updateCategory(.general, isSelected: isSelected)
     }

     func setAnimeSelected(_ isSelected: Bool) {
         updateCategory(.anime, isSelected: isSelected)
     }
    
    private func updatePurity(_ purity: Purity, isSelected: Bool) {
        if isSelected {
            if purities.contains(purity) == false {
                purities.append(purity)
            }
        } 
        else {
            if purities.contains(purity) == false {
                purities.removeAll(where: { p in
                    purity == p
                })
            }
            
        }
    }
    private func updateCategory(_ category: Category, isSelected: Bool) {
        if isSelected {
            if categories.contains(category) == false {
                categories.append(category)
            }
        } else {
            if categories.contains(category) {
                categories.removeAll(where: { c in
                    category == c
                })
            }
            
        }
    }
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
