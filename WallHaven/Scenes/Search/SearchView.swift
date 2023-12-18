import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isPopularSearchesExpanded = true
    @State private var isRecentSearchesExpanded = true
    @State private var isSearchBarPresented = false
    @State private var showWallpapers = false
    
    @State private var configs = WallpaperConfigs()

    // TODO: Replace with something idk - TBD
    private var popularSearches = [
        "First",
        "Second",
        "Third"
    ]
    // TODO: Replace with swift Data
    @State private var recentSearches = [
        "Fourth",
        "Fifth",
        "Sixth"
    ]

    var body: some View {
        NavigationStack {
            if showWallpapers {
                ImageGridView(configs: $configs)
            } else {
                VStack(alignment: .leading) {
                    List {
                        Section("Popular searches", isExpanded: $isPopularSearchesExpanded) {
                            ForEach(popularSearches, id: \.self) { item in
                                NavigationLink(destination: Text("Detail View for \(item)")) {
                                    Text(item)
                                }
                            }
                        }
                        
                        Section("Recent searches", isExpanded: $isRecentSearchesExpanded) {
                            ForEach(recentSearches, id: \.self) { item in
                                NavigationLink(destination: Text("Detail View for \(item)")) {
                                    Text(item)
                                }
                            }
                            .onDelete(perform: { indexSet in
                                recentSearches.remove(atOffsets: indexSet)
                            })
                        }
                    }
                    .listStyle(.sidebar)
                }
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchText, isPresented: $isSearchBarPresented, prompt: "Enter a search term")
        .onSubmit(of: .search) {
            withAnimation {
                configs.query = searchText
                showWallpapers = true
            }
            print("Searching for \(searchText)")
        }
        .onChange(of: searchText) {
            if searchText.isEmpty {
                withAnimation {
                    showWallpapers = false
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
