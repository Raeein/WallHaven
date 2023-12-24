import SwiftUI
import TipKit

struct HomeView: View {

    @StateObject var configs = WallpaperConfigs()
    
    private let filterTip = FilterTip()
    private let refreshTip = RefreshTip()
    
    @State private var refreshWallpapers = false
    
    var body: some View {

        NavigationStack {
            ImageGridView(configs: configs, refreshWallpapers: $refreshWallpapers)
                .toolbar(content: {
//                    #if os(iOS)
//                    ToolbarItemGroup(placement: ToolbarItemPlacement.topBarTrailing) {
                    #warning("Check if this correct")
                    ToolbarItemGroup(placement: ToolbarItemPlacement.automatic) {
//                    #endif
//                    #if os(macOS)
//                    ToolbarItemGroup(placement: ToolbarItemPlacement.confirmationAction) {
//                    #endif
                                            
                        Button(action: {
                            refreshWallpapers = true
                            FilterTip.hasViewedRefreshTip = true
                        }) {
                            Label("Refresh", systemImage: "arrow.clockwise")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                        .popoverTip(refreshTip)
                        
                        Button(action: {}) {
                            Label("Filter", systemImage: "line.3.horizontal.decrease")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                        .popoverTip(filterTip)
              
                    }
                })
                .navigationTitle("Home")
        }
    }
}

//#Preview {
//    HomeView(wallpapers: LocalImage.getSampleImages())
//        .task {
//            try? Tips.resetDatastore()
//            try? Tips.configure([
//                .displayFrequency(.immediate),
//                .datastoreLocation(.applicationDefault)
//            ])
//        }
//
//}
