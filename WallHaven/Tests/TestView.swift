import SwiftUI

struct ImageViewTest: View {

    private let wallpaperPath = "https://w.wallhaven.cc/full/7p/wallhaven-7pmj9o.jpg"

    var body: some View {
        ZStack(alignment: .center) {
            NavigationLink("CLICK ME") {
                Text("Im there")
            }
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

struct DestinationView: View {
    var body: some View {
        Color(.red)
            .ignoresSafeArea()
        Text("Destination View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}


struct TestViewContextMenu: View {
    
    @State private var navigate = false
    @State private var viewOpacity = 0.0

    var body: some View {
        
        NavigationStack {
            VStack {
                Button("Go to Destination") {
                    withAnimation {
                        navigate = true
                        viewOpacity = 1.0
                    }
                }
            }
            .overlay {
                if navigate {
                    DestinationView()
                        .opacity(viewOpacity)
                }
                
            }
            
        }
    }
}


// #Preview {
//    ImageViewTest()
// }
#Preview {
    TestViewContextMenu()
}
