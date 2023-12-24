import SwiftUI

struct FilterData: Identifiable {
    var id = UUID()
    var title: String
    var isSelected: Bool = false
}

struct FilterView: View {
    
    @ObservedObject var viewModel: FilterViewModel

    init(configs: WallpaperConfigs) {
        viewModel = FilterViewModel(configs: configs)
    }
    
    var body: some View {
        NavigationStack {

            List {
                Section {
                    EnumCell(isChecked: $viewModel.isPeopleSelected, text: Category.people.rawValue, onTap: viewModel.updatePeopleFilter)
                    
                    EnumCell(isChecked: $viewModel.isGeneralSelected, text: Category.general.rawValue, onTap: viewModel.updateGeneralFilter)
                    
                    EnumCell(isChecked: $viewModel.isAnimeSelected, text: Category.anime.rawValue, onTap: viewModel.updateAnimeFilter)
                   
      
                } header: {
                    Text("Categories")
                }


                Section {
                    EnumCell(isChecked: $viewModel.isNSFWSelected, upperCased: true, text: Purity.nsfw.rawValue, onTap: viewModel.updateNSFWFilter)
                    
                    EnumCell(isChecked: $viewModel.isSFWSelected, upperCased: true, text: Purity.sfw.rawValue, onTap: viewModel.updateSFWFilter)
                    
                    EnumCell(isChecked: $viewModel.isSketchySelected, upperCased: true, text: Purity.sketchy.rawValue, onTap: viewModel.updateSketchyFilter)
                   
      
                } header: {
                    Label("Purity", systemImage: "18.circle.fill")
                        .foregroundColor(.red)
                }
                
                
                Section {
                    Picker("Sort By", selection: $viewModel.configs.sorting) {
                        ForEach(Sorting.allCases, id: \.self) { sort in
                            Text(sort.rawValue).tag(sort)
                        }
                    }
                    Picker("Order By", selection: $viewModel.configs.order) {
                        ForEach(Order.allCases, id: \.self) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                } footer: {
                    Text("Choose the top range of which the wallpapers would be sorted in by")
                }
                
                Section {
                    Picker("Top Range", selection: $viewModel.configs.topRange) {
                        ForEach(TopRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                } footer: {
                    Text("Choose the sort by and ordering")
                }
                   
                Group {
                    Button("Reset All") { viewModel.configs.resetFilters() }
                    .buttonStyle(.borderedProminent)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
            }
            .onAppear(perform: { viewModel.configureFilterValues() })
            .navigationTitle("Filters")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
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



