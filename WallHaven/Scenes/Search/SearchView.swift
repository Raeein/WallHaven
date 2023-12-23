import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""
    @State private var isPopularSearchesExpanded = true
    @State private var isRecentSearchesExpanded = true
    @State private var isSearchBarPresented = true
    @State private var showWallpapers = false
    @State private var showFilterSheet = false
    
    @StateObject private var configs = WallpaperConfigs()
    
    @Environment(\.modelContext) private var modelContext
    
    // TODO: Replace with something idk - TBD
    private var popularSearches = [
        "First",
        "Second",
        "Third"
    ]

    @Query(sort: \SearchItem.timestamp) private var recentSearches: [SearchItem]
    
    private func addSearchItem(searchText: String) {
        withAnimation {
            let newItem = SearchItem(searchText: searchText, timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteSearchItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(recentSearches[index])
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if showWallpapers {
                    ImageGridView(configs: configs)
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
                                    NavigationLink(destination: Text("Detail View for \(item.searchText)")) {
                                        Text(item.searchText)
                                    }
                                }
                                .onDelete(perform: deleteSearchItems)
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
                FilterView(configs: configs)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
                    .onDisappear(perform: {
                        if (configs.query != nil) && configs.query != "" {
                            showWallpapers = true
                        }
                    })
            })
        }
        .searchable(text: $searchText, isPresented: $isSearchBarPresented, prompt: "Enter a search term")
        .onSubmit(of: .search) {
            addSearchItem(searchText: searchText)
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
            .modelContainer(for: SearchItem.self, inMemory: true)
    }
}
