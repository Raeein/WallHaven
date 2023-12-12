import SwiftUI

struct RootView: View {
    @State var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(1)
            
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(2)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(3)
        })
        .background(.black)
        .foregroundStyle(.black)
        .font(.system(size: 22))

    }
}

#Preview {
    RootView()
}
