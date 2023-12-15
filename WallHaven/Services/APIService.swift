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

    func getRecommendations() async -> [Wallpaper] {
        var wallpapers = [Wallpaper]()
        do {
            let url = URL(string: Constants.WallHavenURL.search())!
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
}


