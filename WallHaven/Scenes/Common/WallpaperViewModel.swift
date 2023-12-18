import SwiftUI

class WallpaperViewModel: ObservableObject {
    
    @Published var wallpapers = [Wallpaper]()
    @Published var showRefreshing = false

    private var currentPage = 1
    private let apiService = APIService()
    private var isLoading = false
    
    func loadWallpapers(config: WallpaperConfigs) {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            let newWallpapers = await apiService.getWallpapers(configs: config)
            DispatchQueue.main.async {
                self.wallpapers.append(contentsOf: newWallpapers)
                self.currentPage += 1
                self.isLoading = false
                self.showRefreshing = false
            }
        }
    }
}
