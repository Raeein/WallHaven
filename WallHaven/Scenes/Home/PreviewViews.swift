import SwiftUI

struct LockScreenPreview: View {
    var wallpaperImage: Image

    var body: some View {
        ZStack {
            wallpaperImage
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .containerRelativeFrame(.horizontal)
            
            VStack {

                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.white)
                Text("9:41 AM")
                    .font(.system(size: 60, weight: .medium, design: .default))
                    .foregroundColor(.white)

                Text("Monday, January 1")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.white)
                
                Spacer()


                HStack {
                    Button(action: {
                        // Action for Flashlight
                    }) {
                        Color(.gray)
                            .clipShape(.circle)
                            .frame(width: 64, height: 64)
                            .opacity(0.8)
                            .overlay {
                                Image(systemName: "flashlight.off.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        // Action for Flashlight
                    }) {
                        Color(.gray)
                            .clipShape(.circle)
                            .frame(width: 64, height: 64)
                            .opacity(0.8)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
    }
}

struct AppIcon {
    let imageName: String
    let appName: String
}


struct AppIconView: View {
    let appIcon: AppIcon

    var body: some View {
        VStack {
            Image(appIcon.imageName, bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            Text(appIcon.appName)
                .font(.caption)
        }
    }
}

struct HomeScreenPreview: View {
    var wallpaperImage: Image
    let appIcons = [
        AppIcon(imageName: "app-store", appName: "App Store"),
        AppIcon(imageName: "apple-music", appName: "Music"),
        AppIcon(imageName: "apple-store", appName: "Store"),
        AppIcon(imageName: "apple-tv", appName: "TV"),
        // Add more icons here...
    ]
    let columns = 4

    var body: some View {
        ZStack {
            wallpaperImage
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .containerRelativeFrame(.horizontal)
  
            VStack(spacing: 20) {
                Spacer()
                ForEach(0..<appIcons.count, id: \.self) { index in
                    if index % columns == 0 { // Start of a new row
                        HStack(spacing: 20) {
                            ForEach(0..<columns, id: \.self) { column in
                                let iconIndex = index + column
                                if iconIndex < appIcons.count {
                                    AppIconView(appIcon: appIcons[iconIndex])
                                }
                            }
                        }
                    }
                }
                HStack {
                    Color(.gray)
                    Color(.gray)
                }
                GroupBox {
                    Image("Gear")
                }.padding()
                
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    HomeScreenPreview(wallpaperImage: LocalImage.getSampleImages().first!)
}

#Preview {
    LockScreenPreview(wallpaperImage: LocalImage.getSampleImages().first!)
}
