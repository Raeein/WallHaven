import Foundation

enum APIError: Error {
    case unauthorized
    case notFound
    case serverError
    case unknownError(String)
    case decodingError(Error)
    case other(Error)
}

struct APIService {

    func getRecommendations(page: Int? = nil) async -> [Wallpaper] {
        var wallpapers = [Wallpaper]()
        let seed = generateSeed()
        do {
            var url = URL(string: Constants.WallHavenURL.search())!
                .appending("seed", value: seed)
                .appending("sorting", value: "random")
            
            if let page = page {
                url = url.appending("page", value: String(page))
            }
            
            print("URL is \(url.absoluteString)")
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
}
