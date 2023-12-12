import SwiftUI

struct HomeView: View {
    @State private var wallpapers: Set<Wallpaper> = Set()
    
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight = UIScreen.main.bounds.height
    
    @State private var columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    
    
    func getRecommendations() {
        Task {
            do {
                let url = URL(string: "https://wallhaven.cc/api/v1/search")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(WallpaperResponse.self, from: data)
                
                for wallpaper in response.data {
                    wallpapers.insert(wallpaper)
                }
                
            } catch  {
                wallpapers = []
                print(error)
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 1) {
                    ForEach(wallpapers.sorted(by: { $0.id < $1.id }), id: \.self) { wallpaper in
                        
                        NavigationLink {
                            ImageView(wallpaper: wallpaper)
                        } label: {
                            AsyncImage(url: URL(string: wallpaper.thumbs.small)) { phase in
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
                                        .onAppear(perform: {
                                            self.wallpapers.remove(wallpaper)
                                        })
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFill()
                                        .frame(
                                            width: cellWidth / 3,
                                            height: cellHeight / 2.5
                                        )                                        .clipped()
                                        .cornerRadius(8)
                                    
                                @unknown default:
                                    fatalError()
                                }
                                
                            }
                        }
                    }
                    
                    
                }
            }
            .navigationTitle("Home")
            .toolbar(content: {
                Button {
                    print("Hi")
                } label: {
                    Label("filter", systemImage: "line.3.horizontal.decrease")
                }
                .font(.largeTitle)
            })
            .onAppear(perform: getRecommendations)
            
        }
    }
}


#Preview {
    HomeView()
}
