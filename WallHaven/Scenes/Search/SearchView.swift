import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""
    @State private var isPopularSearchesExpanded = false
    @State private var isRecentSearchesExpanded = true
    @State private var isViewedSearchesExpanded = false
    
    @State private var isSearchBarPresented = false
    @State private var showWallpapers = false
    @State private var showFilterSheet = false
    @State var refreshWallpapers = false
    
    @StateObject private var configs = WallpaperConfigs()
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var popularSearches = [Tag]()
    @State private var viewedSearches = [Tag]()

    @Query(sort: \SearchItem.timestamp) private var recentSearches: [SearchItem]
    
    private func addSearchItem(searchText: String) {
        let predicate = #Predicate<SearchItem> { object in
            object.searchText == searchText
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        let res = try! modelContext.fetch(descriptor)
        
        guard res.count == 0 else { return }
        
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
                    ImageGridView(configs: configs, refreshWallpapers: $refreshWallpapers)
                } else {
                    VStack(alignment: .leading) {
                        List {
                            Section("Recent searches", isExpanded: $isRecentSearchesExpanded) {
                                ForEach(recentSearches, id: \.id) { item in
                                    HStack {
                                        Text(item.searchText)
                                        Spacer()
                                        Image(systemName: "chevron.forward.circle")
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation {
                                            searchText = item.searchText
                                            configs.query = item.searchText
                                            showWallpapers = true
                                        }
                                        
                                    }
                                }
                                .onDelete(perform: deleteSearchItems)
                            }
                            
                            Section("Popular searches", isExpanded: $isPopularSearchesExpanded) {
                                ForEach(popularSearches, id: \.id) { item in
                                    HStack {
                                        Text(item.tagName)
                                        Spacer()
                                        Image(systemName: "chevron.forward.circle")
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation {
                                            searchText = item.tagName
                                            configs.query = item.tagName
                                            showWallpapers = true
                                        }
                                        
                                    }
                    
                                }
                            }
                            
                            Section("Most Viewed searches", isExpanded: $isViewedSearchesExpanded) {
                                ForEach(viewedSearches, id: \.id) { item in
                                    HStack {
                                        Text(item.tagName)
                                        Spacer()
                                        Image(systemName: "chevron.forward.circle")
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation {
                                            searchText = item.tagName
                                            configs.query = item.tagName
                                            showWallpapers = true
                                        }
                                        
                                    }
                    
                                }
                            }
                        }
                        .listStyle(.sidebar)
                    }
                }
            }
            .task {
                await popularSearches = APIService().getTags(tagType: .popular)
                await viewedSearches = APIService().getTags(tagType: .viewed)
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
            .onChange(of: searchText) {
                if searchText.isEmpty && showWallpapers {
                    withAnimation {
                        showWallpapers = false
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet, content: {
                FilterView(configs: configs)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            })
            .onChange(of: showFilterSheet) {
                if showFilterSheet == false {
                    refreshWallpapers = true
                } 
            }
            .searchable(text: $searchText, isPresented: $isSearchBarPresented, prompt: "Enter a search term")
            .onSubmit(of: .search) {
                addSearchItem(searchText: searchText)
                print(configs.getConfigsDescription())
                print(configs.categories)
                print(configs.purities)
                withAnimation {
                    configs.query = searchText
                    showWallpapers = true
                }
                print("Searching for \(searchText)")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @State static var refreshWallpapers = false // State variable for the binding
    static var previews: some View {
        SearchView() // needs binding
    }
}
