import SwiftUI

struct ImageGridViewCell: View {
    let wallpaper: Wallpaper
    let imageQuality: String
    
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationLink {
            ImageView(wallpaper: wallpaper)
        } label: {
            AsyncImage(url: URL(string: imageQuality)) { phase in

                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(
                            width: cellWidth / 3,
                            height: cellHeight / 2.5
                        )
                        .background(.gray)
                        .cornerRadius(8)
                case .failure:
                    Text("Failed")
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                        .frame(
                            width: cellWidth / 3,
                            height: cellHeight / 2.5
                        )                                        .clipped()
                    //                                        .cornerRadius(8)

                @unknown default:
                    fatalError()
                }
            }
        }
    }
}

struct ImageGridView: View {
    @State private var columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    @AppStorage("imageQuality") private var imageQuality: ImageQuality = .low

    private let apiService = APIService()

    private let filterTip = FilterTip()
    private let refreshTip = RefreshTip()
    
    @StateObject var viewModel = WallpaperViewModel()
    
    
    @State private var wallpaperShownCount = 0

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(viewModel.wallpapers, id: \.self) { wallpaper in
                    ImageGridViewCell(
                        wallpaper: wallpaper,
                        imageQuality: (imageQuality == .high ? wallpaper.thumbs.original : wallpaper.thumbs.small)
                    ).onAppear {
                        wallpaperShownCount += 1
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
                viewModel.loadWallpapers()
            }
        })
        .onAppear(perform: {
            viewModel.loadWallpapers()
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

//#Preview {
//    ImageGridView(wallpapers: [])
//}
