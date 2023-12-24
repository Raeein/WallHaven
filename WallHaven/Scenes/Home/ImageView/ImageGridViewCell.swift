import SwiftUI

struct ImageGridViewCell: View {
    
    let wallpaper: Wallpaper
    let imageQuality: String
    
    #if os(iOS)
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight = UIScreen.main.bounds.height
    #endif
    #if os(macOS)
    private let cellWidth = NSScreen.main?.visibleFrame.size.width ?? 200
    private let cellHeight = NSScreen.main?.visibleFrame.size.height ?? 200
    #endif
    
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
