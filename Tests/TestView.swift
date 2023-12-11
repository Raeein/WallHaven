import SwiftUI

struct ImageViewTest: View {
    
    private let wallpaperPath = "https://w.wallhaven.cc/full/7p/wallhaven-7pmj9o.jpg"
    
    var body: some View {
        ZStack(alignment: .center) {
            AsyncImage(url: URL(string: wallpaperPath)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .failure:
                    Text("Failed to fetch image")
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                
                        .clipped()
                @unknown default:
                    fatalError()
                }
            }
            .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                HStack {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(.blue)
                    }
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.down.circle")
                            .foregroundStyle(.blue)
                        
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
}


#Preview {
    ImageViewTest()
}
