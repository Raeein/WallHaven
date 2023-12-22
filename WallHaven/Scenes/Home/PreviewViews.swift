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

struct HomeScreenPreview: View {
    var wallpaperImage: Image

    var body: some View {
        ZStack {
            wallpaperImage
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            // Add mock app icons and home screen elements
        }
    }
}

#Preview {
    HomeScreenPreview(wallpaperImage: LocalImage.getSampleImages().first!)
}

#Preview {
    LockScreenPreview(wallpaperImage: LocalImage.getSampleImages().first!)
}
