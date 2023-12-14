import Foundation

struct APIService {
    func getRecommendations() async -> [Wallpaper] {
        var wallpapers = [Wallpaper]()
        do {
            let url = URL(string: "https://wallhaven.cc/api/v1/search")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WallpaperResponse.self, from: data)
            
            for wallpaper in response.data {
                wallpapers.append(wallpaper)
            }
        } catch {
            print(error)
        }
        return wallpapers   
    }
    
    func verifyAPIKey() -> Bool {
        return true
    }
}


