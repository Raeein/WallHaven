import SwiftUI
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageView: View {

    init(wallpaper: Wallpaper, currentImage: UIImage? = nil) {
        self.wallpaper = wallpaper
    }

    private func openPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
    
    private func setAverageColor() {
        guard let currentImage else { return }
        let uiColor = currentImage.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }

    private let wallpaper: Wallpaper
    private let alertMessage = "To save photos, please allow photos access to WallHaven in your iPhone settings"
    @State private var currentImage: UIImage?
    @State private var showToast = false
    @State private var showInfo = false
    @State private var showAlert = false
    @State private var imageSaved = false
    @State private var backgroundColor: Color = .black

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
                            setAverageColor()
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
                if showInfo {
                    GroupBox {
                        VStack(alignment: .leading) {
                            Text("Views: " + wallpaper.getViews())
                            Text("Favorites: " + wallpaper.getFavorites())
                            Text("Resolution: \(wallpaper.resolution)")
                            Text("File Size: " + wallpaper.getFileSize())
                        }
                    }
                    .transition(.scale)
                    .padding()
                }
                Spacer()
                HStack {
                    Button(action: {
                        checkPhotoLibraryPermission { canSave in
                            if canSave {
                                saveImage(imageToSave: currentImage)
                                imageSaved.toggle()
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
                        ImageViewTabItem(imageName: "camera.filters", imageNameDesc: "Blur")
                    }

                    Spacer()

                    Button(action: { withAnimation { showInfo.toggle()} }) {
                        ImageViewTabItem(imageName: "info.circle", imageNameDesc: "Info")
                    }
                }
                .padding([.horizontal, .top])
                .background(backgroundColor.opacity(0.7))
                
            }
        }
        .onTapGesture {
            if showInfo {
                withAnimation {
                    showInfo.toggle()
                }
            }
        }
        .alert("Enable Access", isPresented: $showAlert, actions: {
            Button("Take Me There", role: .cancel) {
                openPrivacySettings()
            }
            Button("Dismiss", role: .destructive) {
                showAlert = false
            }
        }, message: {
            Text(alertMessage)
        })
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
        .sensoryFeedback(.success, trigger: imageSaved)
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
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(.white)

            Text(imageNameDesc)
                .foregroundStyle(.white)
                .font(.footnote)
                .bold()
        }
    }
}
