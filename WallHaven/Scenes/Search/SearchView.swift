import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isPopularSearchesExpanded = true
    @State private var isRecentSearchesExpanded = true
    @State private var isSearchBarPresented = true
    @State private var showWallpapers = false
    @State private var showFilterSheet = false
    
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
            Group {
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
            .toolbar(content: {
                ToolbarItemGroup(placement: ToolbarItemPlacement.topBarTrailing) {
                    Button(action: { showFilterSheet.toggle() }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
            })
//            .navigationTitle("Search")
            .onChange(of: searchText) {
                if searchText.isEmpty || showWallpapers {
                    withAnimation {
                        showWallpapers = false
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet, content: {
                FilterView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            })
        }
        .searchable(text: $searchText, isPresented: $isSearchBarPresented, prompt: "Enter a search term")
        .onSubmit(of: .search) {
            withAnimation {
                configs.query = searchText
                showWallpapers = true
            }
            print("Searching for \(searchText)")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
