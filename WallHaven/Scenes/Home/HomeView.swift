import SwiftUI
import TipKit

struct HomeView: View {

    @Binding var wallpapers: [Wallpaper]
    @StateObject var configs = WallpaperConfigs()
    
    var body: some View {

        NavigationStack {
            ImageGridView(configs: configs)
        }
    }
}
//
//#Preview {
//    HomeView(wallpapers: [])
//        .task {
//            try? Tips.resetDatastore()
//            try? Tips.configure([
//                .displayFrequency(.immediate),
//                .datastoreLocation(.applicationDefault)
//            ])
//        }
//
//}
