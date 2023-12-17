import SwiftUI

class WallpaperViewModel: ObservableObject {
    
    @Published var wallpapers = [Wallpaper]()
    @Published var showRefreshing = false

    private var currentPage = 1
    private let apiService = APIService()
    private var isLoading = false
    
    func loadWallpapers() {
        guard !isLoading else { return }
        
        isLoading = true
        Task {
            let newWallpapers = await apiService.getRecommendations(page: currentPage)
            DispatchQueue.main.async {
                self.wallpapers.append(contentsOf: newWallpapers)
                self.currentPage += 1
                self.isLoading = false
                self.showRefreshing = false
            }
        }
    }
}
