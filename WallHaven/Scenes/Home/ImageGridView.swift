import SwiftUI

struct ImageGridView: View {
    @State private var columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    @AppStorage("imageQuality") private var imageQuality: ImageQuality = .low
    @StateObject var viewModel = WallpaperViewModel()
    @ObservedObject var configs: WallpaperConfigs
    @State private var wallpaperShownCount = 0

    private let apiService = APIService()
    private let filterTip = FilterTip()
    private let refreshTip = RefreshTip()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(viewModel.wallpapers, id: \.self) { wallpaper in
                    ImageGridViewCell(
                        wallpaper: wallpaper,
                        imageQuality: (imageQuality == .high ? wallpaper.thumbs.original : wallpaper.thumbs.small)
                    )
                    .onAppear { wallpaperShownCount += 1 }
                    .contextMenu {
                        Button("Download") {
                            // TODO: Add download stuff here
                            print("Download me")
                        }
                        Button("Favourite") {
                            // TODO: Add download stuff here
                            print("Download me")
                        }
                    }
                }
            }
            if viewModel.showRefreshing {
                ProgressView()
            }
        }
        .onChange(of: wallpaperShownCount, {
            if wallpaperShownCount == viewModel.wallpapers.count {
                viewModel.showRefreshing = true
                viewModel.loadWallpapers(config: configs)
            }
        })
        .onAppear(perform: {
            viewModel.loadWallpapers(config: configs)
            print("image quality is\(imageQuality)")
        })
        .navigationTitle("Home")
        .toolbar(content: {
            ToolbarItemGroup(placement: ToolbarItemPlacement.topBarTrailing) {
                Button(action: {}) {
                    Label("Filter", systemImage: "line.3.horizontal.decrease")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                .popoverTip(filterTip)

                Button(action: {
                    FilterTip.hasViewedRefreshTip = true
                }) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                .popoverTip(refreshTip)
            }
        })
    }
}
