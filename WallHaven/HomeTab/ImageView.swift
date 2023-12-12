import SwiftUI

import Photos



struct ImageView: View {
    
    init(wallpaper: Wallpaper, currentImage: UIImage? = nil) {
        self.wallpaper = wallpaper
    }
    
    func saveImage(imageToSave: UIImage?) {
        guard let imageToSave = imageToSave else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: imageToSave)
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        case .restricted, .denied:
            completion(false)
        case .authorized, .limited:
            completion(true)
        @unknown default:
            completion(false)
        }
    }

    
    private let wallpaper: Wallpaper
    private let alertMessage = "To save photos, please allow photos access to WallHaven in your iPhone settings"
    @State private var currentImage: UIImage?
    @State private var showToast = false
    @State private var showAlert = false
    @State private var imageSaved = false
    
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
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .containerRelativeFrame(.horizontal)
                        .ignoresSafeArea(.all)
                        .onAppear(perform: {
                            currentImage = ImageRenderer(content: image).uiImage
                        })
                        
                @unknown default:
                    fatalError()
                }
            }
            
            VStack {
                if showToast {
                    Label("Image successfully saved to photos", systemImage: "info.circle")
                        .padding()
                        .transition(.scale)
                        .background(.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                Spacer()
                HStack {
                    Button(action: {
                        checkPhotoLibraryPermission { canSave in
                            if canSave {
                                saveImage(imageToSave: currentImage)
                                withAnimation(.easeInOut) {
                                    showToast.toggle()
                                }
                            } else {
                                showAlert = true
                            }
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
        .alert(alertMessage, isPresented: $showAlert) {
            Button("Dismiss", role: .cancel) {
                        showAlert = false
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
