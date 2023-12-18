import SwiftUI
import Lottie

struct RootView: View {
    @State var selectedTab = 0
    @State private var wallpaperLoading = true
    @State private var animateGradient = true
    @State private var wallpapers = [Wallpaper]()

    var body: some View {

        VStack {
            if wallpaperLoading {
                ZStack {
                    Color(.clear)
                        .ignoresSafeArea(.all)
                    LottieView(animation: .named(Constants.Lottie.loading))
                        .playing(loopMode: .loop)
                        .frame(width: 200, height: 200)

                }
                .background(content: {
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                    .hueRotation(.degrees(animateGradient ? 45 : 0))
                    .onAppear(perform: {
                        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    })
                })
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            self.wallpaperLoading = false
                        }
                    }
                })
            } else {
                TabView(selection: $selectedTab,
                        content: {
                    HomeView(wallpapers: $wallpapers)
                        .tabItem { Label("Home", systemImage: "house.fill") }
                        .tag(1)

                    SearchView()
                        .tabItem { Label("Search", systemImage: "magnifyingglass") }
                        .tag(2)

                    SettingsView()
                        .tabItem { Label("Settings", systemImage: "gear") }
                        .tag(3)
                })
            }
        }
        .task {
            wallpapers = await APIService().getWallpapers()
        }
    }
}

#Preview {
    RootView()
}
