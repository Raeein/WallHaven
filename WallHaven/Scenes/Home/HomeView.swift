import SwiftUI
import TipKit

struct HomeView: View {

    @Binding var wallpapers: [Wallpaper]
    var body: some View {

        NavigationStack {
            ImageGridView()
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
