import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedSearchItem: String?
    @State private var isPopularSearchesExpanded = true
    @State private var isRecentSearchesExpanded = true
    
    private var popularSearches = [
        "First",
        "Second",
        "Third",
        "Third"
    ]
    
    private var recentSearches = [
        "First",
        "Second",
        "Third",
        "Third"
    ]
    
    var body: some View {
        NavigationStack {
            if searchText.isEmpty {
                VStack(alignment: .leading, content: {
 
//                    List(popularSearches, id: \.self, selection: $selectedSearchItem) { item in
//                             Text(item)
//                                 .onTapGesture {
//                                     selectedSearchItem = item
//                                 }
//                         }
                    
                    List {
                        
                        Section("Popular searches", isExpanded: $isPopularSearchesExpanded) {
                            ForEach(popularSearches, id: \.self) { section in
                                Text(section)
                            }
                        }
                        
                        Section("Recent searches", isExpanded: $isRecentSearchesExpanded) {
                                ForEach(recentSearches, id: \.self) { section in
                                    Text(section)
                                    
                                }
                        }
                    }
                    .listStyle(.sidebar)
                    
//                    Spacer()
//                    Text("Searching for \(searchText)")
//                        .navigationTitle("Search")
                })
//                .background(.red)
            }
         }
         .searchable(text: $searchText)
    }
}

#Preview {
    SearchView()
}
