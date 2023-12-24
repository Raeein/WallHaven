import SwiftUI
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

struct ImageView: View {

    @StateObject private var viewModel = ImageViewViewModel()
    
    init(wallpaper: Wallpaper) {
        self.wallpaper = wallpaper
    }

    private let wallpaper: Wallpaper
    private let alertMessage = "To save photos, please allow photos access to WallHaven in your iPhone settings"

    var body: some View {
        ZStack(alignment: .center) {
            if let filteredImage = viewModel.filteredImage {
                filteredImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .containerRelativeFrame(.horizontal)
                    .ignoresSafeArea(.all)
                    .onAppear(perform: {
                        viewModel.setAverageColor()
                    })
            } else if let originalImage = viewModel.originalImage {
                originalImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .containerRelativeFrame(.horizontal)
                    .ignoresSafeArea(.all)
                    .onAppear(perform: {
                        viewModel.setAverageColor()
                        viewModel.originalUIImage = originalImage.getUIImage()
                    })
            } else {
                ProgressView()
            }
            
            VStack {
                if viewModel.showToast {
                    Label("Image successfully saved to photos", systemImage: "info.circle")
                        .padding()
                        .transition(.scale)
                        .background(.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                if viewModel.showInfo {
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
                    .backgroundStyle(viewModel.backgroundColor.opacity(0.85))
                    .transition(.scale)
                    .padding()
                }
                Spacer()
                VStack {
                    if let originalImage = viewModel.originalImage, viewModel.showBlurSlider {
                        VStack {
                            Slider(value: $viewModel.blurValue, in: 0...25, step: 1) { isEditing in
                                withAnimation {
                                    viewModel.isEditingSlider = isEditing
                                    if !isEditing {
                                        viewModel.applyBlueFilter(image: originalImage, radius: Float(viewModel.blurValue))
                                    }
                                }
                            }
                            .foregroundStyle(.red)
                            .backgroundStyle(.purple)
                            .padding(.horizontal)
                            
                            Text("\(viewModel.blurValue * 4, specifier: "%.0f")%")
                                .foregroundStyle(viewModel.isEditingSlider ? .white : .gray)
                        }
                    }
                    if viewModel.showPreviews {
                        VStack{
                            Button(action: {
                                withAnimation {
                                    viewModel.showHomeScreen = true
                                    viewModel.viewOpacity = 1
                                }
                            }) {
                                ImageViewTabItem(imageName: "house.fill")
                            }
                            .padding()
                            
                            Button(action: {
                                withAnimation {
                                    viewModel.showLockScreen = true
                                    viewModel.viewOpacity = 1
                                }
                            }) {
                                ImageViewTabItem(imageName: "lock.fill")
                            }
                        }
                    }
                    HStack {
                        Button(action: {
                            viewModel.checkPhotoLibraryPermission { canSave in
                                if canSave {
                                    viewModel.saveImage(imageToSave: viewModel.filteredUIImage ?? viewModel.originalUIImage!)
                                    viewModel.imageSaved.toggle()
                                    withAnimation(.easeInOut) {
                                        viewModel.showToast.toggle()
                                    }
                                } else {
                                    viewModel.showAlert = true
                                }
                            }
                        }) {
                            ImageViewTabItem(imageName: "arrow.down.circle", imageNameDesc: "Download")
                        }
                        
                        Spacer()
                    

                        Button(action: { withAnimation { viewModel.showPreviews.toggle() }}) {
                                ImageViewTabItem(imageName: "eye.fill", imageNameDesc: "Preview")
                            }
                            
            
                        Spacer()
                        
                        
                        Button(action: { withAnimation { viewModel.showBlurSlider.toggle() }}) {
                            ImageViewTabItem(imageName: "camera.filters", imageNameDesc: "Blur")
                        }
                        

                        Spacer()
                        
                        Button(action: { withAnimation { viewModel.showInfo.toggle()} }) {
                            ImageViewTabItem(imageName: "info.circle", imageNameDesc: "Info")
                        }
                    }
                    .padding([.horizontal, .top])
                }
                .background(viewModel.backgroundColor.opacity(0.7))
            }
        }
        .overlay(content: {
            if viewModel.showLockScreen {
                LockScreenPreview(wallpaperImage: viewModel.originalImage!)
                    .opacity(viewModel.viewOpacity)
                    .onTapGesture {
                        withAnimation {
                            viewModel.showPreviews.toggle()
                            viewModel.showLockScreen.toggle()
                            viewModel.viewOpacity = 0.0
                        }
                    }
            }
            if viewModel.showHomeScreen {
                HomeScreenPreview(wallpaperImage: viewModel.originalImage!)
                    .opacity(viewModel.viewOpacity)
                    .onTapGesture {
                        withAnimation {
                            viewModel.showPreviews.toggle()
                            viewModel.showHomeScreen.toggle()
                            viewModel.viewOpacity = 0.0
                        }
                    }
            }
        })
        .task {
            viewModel.loadImageFromURL(wallpaperURL: wallpaper.path)
        }
        .onTapGesture {
            if viewModel.showInfo {
                withAnimation {
                    viewModel.showInfo.toggle()
                }
            }
            if viewModel.showPreviews {
                withAnimation {
                    viewModel.showInfo.toggle()
                    viewModel.previewType = nil
                }
            }
        }
        .alert("Enable Access", isPresented: $viewModel.showAlert, actions: {
            Button("Take Me There", role: .cancel) {
                viewModel.openPrivacySettings()
            }
            Button("Dismiss", role: .destructive) {
                viewModel.showAlert = false
            }
        }, message: {
            Text(alertMessage)
        })
        #if os(iOS)
        .toolbar(.hidden, for: .tabBar)
        #endif
        .onChange(of: viewModel.showToast, {
            if viewModel.showToast == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut) {
                        viewModel.showToast.toggle()
                    }
                }
            }
        })
        .sensoryFeedback(.success, trigger: viewModel.imageSaved)
    }
}



struct ImageViewTabItem: View {

    private let imageName: String
    private let imageNameDesc: String?

    init(imageName: String, imageNameDesc: String? = nil) {
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
            if let imageNameDesc {
                Text(imageNameDesc)
                    .foregroundStyle(.white)
                    .font(.footnote)
                    .bold()
            }
        }
    }
}
