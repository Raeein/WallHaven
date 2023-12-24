import SwiftUI

struct FilterData: Identifiable {
    var id = UUID()
    var title: String
    var isSelected: Bool = false
}


struct FilterView: View {
    
    @ObservedObject var configs: WallpaperConfigs
    
    // Purities
    @State var isSFWSelected: Bool = false
    @State var isNSFWSelected: Bool = false
    @State var isSketchySelected: Bool = false
    
    // Categories
    @State var isPeopleSelected: Bool = false
    @State var isGeneralSelected: Bool = false
    @State var isAnimeSelected: Bool = false
    
    @State var query: String? = nil
    @State var sorting: Sorting = .random
    @State var order: Order = .desc
    
    
    private func configureFilterValues() {
        isSFWSelected = configs.isSFWSelected()
        isNSFWSelected = configs.isNSFWSelected()
        isSketchySelected = configs.isSketchySelected()
        
        isPeopleSelected = configs.isPeopleSelected()
        isGeneralSelected = configs.isGeneralSelected()
        isAnimeSelected = configs.isAnimeSelected()
        
        query = configs.query
        sorting = configs.sorting
        order = configs.order
    }
    
    var body: some View {
        NavigationStack {

            List {
                Section {
                    EnumCell(isChecked: $isPeopleSelected, text: Category.people.rawValue, onTap: updatePeopleFilter)
                    
                    EnumCell(isChecked: $isGeneralSelected, text: Category.general.rawValue, onTap: updateGeneralFilter)
                    
                    EnumCell(isChecked: $isAnimeSelected, text: Category.anime.rawValue, onTap: updateAnimeFilter)
                   
      
                } header: {
                    Text("Categories")
                }

                

                Section {
                    EnumCell(isChecked: $isNSFWSelected, upperCased: true, text: Purity.nsfw.rawValue, onTap: updateNSFWFilter)
                    
                    EnumCell(isChecked: $isSFWSelected, upperCased: true, text: Purity.sfw.rawValue, onTap: updateSFWFilter)
                    
                    EnumCell(isChecked: $isSketchySelected, upperCased: true, text: Purity.sketchy.rawValue, onTap: updateSketchyFilter)
                   
      
                } header: {
                    Label("Purity", systemImage: "18.circle.fill")
                        .foregroundColor(.red)
                }
                
                
                Section {
                    Picker("Sort By", selection: $configs.sorting) {
                        ForEach(Sorting.allCases, id: \.self) { sort in
                            Text(sort.rawValue).tag(sort)
                        }
                    }
                    Picker("Order By", selection: $configs.order) {
                        ForEach(Order.allCases, id: \.self) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                } footer: {
                    Text("Choose the top range of which the wallpapers would be sorted in by")
                }
                
                
                Section {
                    Picker("Top Range", selection: $configs.topRange) {
                        ForEach(TopRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                } footer: {
                    Text("Choose the sort by and ordering")
                }
                   
                VStack(alignment: .center) {
                    Button("Reset All") {
                        configs.resetFilters()
                    }
                    .buttonStyle(.borderedProminent)
                    .bold()
                }
            }
            .onAppear(perform: {
                configureFilterValues()
            })
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilterView(configs: WallpaperConfigs())
}

struct EnumCell: View {
    @Binding var isChecked: Bool
    @State private var isTapped: Bool = false
    var upperCased: Bool = false
    let text: String
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            if upperCased {
                Text(text.uppercased())
            } else {
                Text(text.capitalized)
            }
            
            Spacer()
            if isChecked {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 12, height: 12)
            }
        }
        .contentShape(Rectangle())
        .scaleEffect(isTapped ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isTapped)
        .onTapGesture(perform: {
            isTapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTapped = false
                onTap()
            }
        })
    }
}


extension FilterView {
    private func updateSFWFilter() {
        isSFWSelected.toggle()
        configs.setSFWSelected(isSFWSelected)
    }

    private func updateNSFWFilter() {
        isNSFWSelected.toggle()
        configs.setNSFWSelected(isNSFWSelected)
    }

    private func updateSketchyFilter() {
        isSketchySelected.toggle()
        configs.setSketchySelected(isSketchySelected)
    }

    private func updatePeopleFilter() {
        isPeopleSelected.toggle()
        configs.setPeopleSelected(isPeopleSelected)
    }

    private func updateGeneralFilter() {
        isGeneralSelected.toggle()
        configs.setGeneralSelected(isGeneralSelected)
    }

    private func updateAnimeFilter() {
        isAnimeSelected.toggle()
        configs.setAnimeSelected(isAnimeSelected)
    }
}
