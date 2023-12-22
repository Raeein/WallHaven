import SwiftUI
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageView: View {

    init(wallpaper: Wallpaper) {
        self.wallpaper = wallpaper
    }
    
    private func loadImageFromURL(wallpaperURL: String) {
        guard let url = URL(string: wallpaperURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.originalImage = Image(uiImage: uiImage)
                }
            }
        }.resume()
    }


    private func openPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func saveImage(imageToSave: UIImage) {
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
        guard let originalUIImage else { return }
        let uiColor = originalUIImage.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }
    
    @MainActor private func applyBlueFilter(image: Image, radius: Float) {
        guard radius != 0.0 else {
            filteredImage = nil
            filteredUIImage = nil
            return
        }
        if originalUIImage == nil {
            originalUIImage = image.getUIImage()
        }
        let beginImage = CIImage(image: originalUIImage!)
        
        let context = CIContext()
        let currentFilter = CIFilter.gaussianBlur()
        
        currentFilter.inputImage = beginImage
        currentFilter.radius = radius
        
        guard let outputImage = currentFilter.outputImage else { return }

        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)

        filteredImage = Image(uiImage: uiImage)
        filteredUIImage = filteredImage?.getUIImage()
    }

    private let wallpaper: Wallpaper
    private let alertMessage = "To save photos, please allow photos access to WallHaven in your iPhone settings"
    @State private var originalUIImage: UIImage?
    @State private var originalImage: Image?
    @State private var filteredImage: Image?
    @State private var filteredUIImage: UIImage?
    @State private var showToast = false
    @State private var showInfo = false
    @State private var showAlert = false
    @State private var imageSaved = false
    @State private var backgroundColor: Color = .black
    @State private var showBlurSlider = false
    @State private var blurValue: Double = 0
    @State private var isEditingSlider = false

    var body: some View {
        ZStack(alignment: .center) {
            if let filteredImage {
                filteredImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .containerRelativeFrame(.horizontal)
                    .ignoresSafeArea(.all)
                    .onAppear(perform: {
                        setAverageColor()
                    })
            } else if let originalImage {
                originalImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .containerRelativeFrame(.horizontal)
                    .ignoresSafeArea(.all)
                    .onAppear(perform: {
                        setAverageColor()
                        originalUIImage = originalImage.getUIImage()
                    })
            } else {
                ProgressView()
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
                                .foregroundStyle(.white)
                            Text("Favorites: " + wallpaper.getFavorites())
                                .foregroundStyle(.white)
                            Text("Resolution: \(wallpaper.resolution)")
                                .foregroundStyle(.white)
                            Text("File Size: " + wallpaper.getFileSize())
                                .foregroundStyle(.white)
                        }
                    }
                    .backgroundStyle(backgroundColor.opacity(0.85))
                    .transition(.scale)
                    .padding()
                }
                Spacer()
                VStack {
                    if let originalImage, showBlurSlider {
                        VStack {
                            Slider(value: $blurValue, in: 0...25, step: 1) { isEditing in
                                withAnimation {
                                    isEditingSlider = isEditing
                                    if !isEditing {
                                        applyBlueFilter(image: originalImage, radius: Float(blurValue))
                                    }
                                }
                            }
                            .foregroundStyle(.red)
                            .backgroundStyle(.purple)
                            .padding(.horizontal)
                            
                            Text("\(blurValue * 4, specifier: "%.0f")%")
                                .foregroundStyle(isEditingSlider ? .white : .gray)
                        }
                    }
                    HStack {
                        Button(action: {
                            checkPhotoLibraryPermission { canSave in
                                if canSave {
                                    saveImage(imageToSave: filteredUIImage ?? originalUIImage!)
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

                        VStack {
                            Button(action: { withAnimation { showBlurSlider.toggle() }}) {
                                ImageViewTabItem(imageName: "camera.filters", imageNameDesc: "Blur")
                            }
                        }

                        Spacer()

                        Button(action: { withAnimation { showInfo.toggle()} }) {
                            ImageViewTabItem(imageName: "info.circle", imageNameDesc: "Info")
                        }
                    }
                    .padding([.horizontal, .top])
                }
                .background(backgroundColor.opacity(0.7))
            }
        }
        .onAppear(perform: {
            loadImageFromURL(wallpaperURL: wallpaper.path)
        })
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
