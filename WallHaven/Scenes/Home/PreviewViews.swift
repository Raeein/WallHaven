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
                .foregroundStyle(.white)
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
        AppIcon(imageName: "files", appName: "Files"),
        AppIcon(imageName: "ios-message", appName: "Messages"),
        AppIcon(imageName: "mail", appName: "Mail"),
        AppIcon(imageName: "notes", appName: "Notes"),
        AppIcon(imageName: "photos", appName: "Photos"),
        AppIcon(imageName: "settings", appName: "Settings"),
        AppIcon(imageName: "weather", appName: "Weather"),
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
                
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        AppIconView(appIcon: appIcons[0])
                        AppIconView(appIcon: appIcons[1])
                        AppIconView(appIcon: appIcons[2])
                        AppIconView(appIcon: appIcons[3])
                    }
                    
                    HStack(spacing: 20) {
                        AppIconView(appIcon: appIcons[4])
                        AppIconView(appIcon: appIcons[5])
                        AppIconView(appIcon: appIcons[6])
                        AppIconView(appIcon: appIcons[7])
                    }
                    HStack(spacing: 20) {
                        AppIconView(appIcon: appIcons[8])
                        AppIconView(appIcon: appIcons[9])
                        AppIconView(appIcon: appIcons[10])
                    }
                }
                .padding(.top)
                
                Spacer()
                GroupBox {
                    HStack(spacing: 20) {
                        AppIconView(appIcon: appIcons[7])
                        AppIconView(appIcon: appIcons[8])
                        AppIconView(appIcon: appIcons[9])
                        AppIconView(appIcon: appIcons[10])
                    }
                    .padding()
                    
                }
                .backgroundStyle(.bar)
                .clipShape(.rect(cornerRadius: 64.0))
                .opacity(0.8)
                .padding()
            }
        }
    
            
            
        
        
    }
}

#Preview {
    HomeScreenPreview(wallpaperImage: LocalImage.getSampleImages().first!)
}

#Preview {
    LockScreenPreview(wallpaperImage: LocalImage.getSampleImages().first!)
}
