import Foundation

struct Constants {
    struct KeyChain {
        static let Service = "com.raeeinbagheri.WallHaven"
        static let Key = "api-key"
    }

    struct Lottie {
        static let checkMarkSuccess = "check"
        static let crossFailure = "cross"
        static let key = "key"
        static let dizzy = "dizzy"
        static let wallpaperLoading = "wallpaper"
        static let loading = "loading"
    }

    struct WallHavenURL {
        static let home = "https://wallhaven.cc"
        static let search = {
            return home + "/api/v1/search"
        }
        static let viewedTags = {
            return home + "/tags/viewed"
        }
        static let popularTags = {
            return home + "/tags/popular"
        }
    }
}
