import SwiftUI
import TipKit


struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ImageGridView()
        }
    }
}


#Preview {
    HomeView()
        .task {
            try? Tips.resetDatastore()
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
    
}

struct ImageGridView: View {
    @State private var columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    
    @State private var wallpapers = [Wallpaper]()
    @AppStorage("imageQuality") private var imageQuality: ImageQuality = .low
    
    @State private var wallpaperLoading = false
    
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight = UIScreen.main.bounds.height
    private let apiService = APIService()
    
    private let filterTip = FilterTip()
    private let refreshTip = RefreshTip()
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(wallpapers, id: \.self) { wallpaper in
                    
                    NavigationLink {
                        ImageView(wallpaper: wallpaper)
                    } label: {
                        AsyncImage(url: URL(string: imageQuality == .high ? wallpaper.thumbs.original : wallpaper.thumbs.small)) { phase in
                            
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
                                //                                        .onAppear(perform: {
                                //                                            self.wallpapers.remove(wallpaper)
                                //                                        })
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
        }
        .onAppear(perform: {
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
        .task {
            wallpapers = await apiService.getRecommendations()
        }
    }
}
