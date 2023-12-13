import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isPopularSearchesExpanded = true
    @State private var isRecentSearchesExpanded = true
    @State private var isSearchBarPresented = false
    
    private var popularSearches = [
        "First",
        "Second",
        "Third"
    ]
    
    @State private var recentSearches = [
        "Fourth",
        "Fifth",
        "Sixth"
    ]
    
    var body: some View {
        NavigationStack {
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
            
            .searchable(text: $searchText, isPresented: $isSearchBarPresented, prompt: "Enter a search term")
            .onSubmit(of: .search) {
                // Handle the search action here
                print("Searching for \(searchText)")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
