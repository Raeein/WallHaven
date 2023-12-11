import SwiftUI

struct ImageView: View {
    
    init(wallpaper: Wallpaper, currentImage: UIImage? = nil) {
        self.wallpaper = wallpaper
    }
    
    func saveImage(imageToSave: UIImage?) {
        guard let imageToSave = imageToSave else { return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }
    
    private let wallpaper: Wallpaper
    @State private var currentImage: UIImage?
    @State private var showToast = false
    
    var body: some View {
        ZStack(alignment: .center) { // Align the content to the bottom
            AsyncImage(url: URL(string: wallpaper.path)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(.circular)
                case .failure:
                    Text("REFRESH")
                case .success(let image):
                    image
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .containerRelativeFrame(.horizontal)
                        .onAppear(perform: {
                            currentImage = ImageRenderer(content: image).uiImage
                        })
                        .ignoresSafeArea(.all)
                @unknown default:
                    fatalError()
                }
            }
            
            VStack{
                Spacer()
                if showToast {
                    Text("Image successfully saved to photos!")
                        .foregroundStyle(.gray)
                        .transition(.move(edge: .bottom))
                }
                HStack {
                    Button(action: {
                        saveImage(imageToSave: currentImage)
                        withAnimation(.easeInOut) {
                            showToast.toggle()
                        }
                    }) {
                        ImageViewTabItem(imageName: "arrow.down.circle", imageNameDesc: "Download")
                    }
                    Spacer()
                    
                    Button(action: {
                        // Handle save Favourite
                    }) {
                        ImageViewTabItem(imageName: "heart", imageNameDesc: "Favourite")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle download info
                    }) {
                        ImageViewTabItem(imageName: "info.circle", imageNameDesc: "Info")
                    }
                }
                
                .padding([.horizontal, .top])
                .background(.ultraThinMaterial)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: showToast, {
            if showToast == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut) {
                        showToast.toggle()
                    }
                }
            }
        })
    }
}

struct ImageViewTabItem: View {
    
    private let imageName: String
    private let imageNameDesc: String
    
    init(imageName: String, imageNameDesc: String) {
        self.imageName = imageName
        self.imageNameDesc = imageNameDesc
    }
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color(UIColor.lightGray))
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.black)
                }
            
            Text(imageNameDesc)
                .foregroundStyle(.blue)
                .font(.footnote)
                .bold()
        }
    }
}
