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
                    EnumCell(isChecked: $isNSFWSelected, text: Purity.nsfw.rawValue, onTap: updateNSFWFilter)
                    
                    EnumCell(isChecked: $isSFWSelected, text: Purity.sfw.rawValue, onTap: updateSFWFilter)
                    
                    EnumCell(isChecked: $isSketchySelected, text: Purity.sketchy.rawValue, onTap: updateSketchyFilter)
                   
      
                } header: {
                    Label("Purity", systemImage: "18.circle.fill")
                        .foregroundColor(.red)
                }
       
                VStack(alignment: .leading) {
                    Button("Clear All") {
                        print("Clearing all")
                    }
                    .buttonStyle(.borderedProminent)
                    .bold()
                    
                    
                    Button(action: {}, label: {
                        HStack {
                            Text("Advanced Search")
                            Image(systemName: "chevron.down")
                            
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .bold()
                }
            }
            .onAppear(perform: {
                configureFilterValues()
            })
//            .navigationTitle("Filters")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilterView(configs: WallpaperConfigs())
}

struct EnumCell: View {
    @Binding var isChecked: Bool
    @State private var isTapped: Bool = false
    let text: String
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(text.uppercased())
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
    }

    private func updateNSFWFilter() {
        isNSFWSelected.toggle()
    }

    private func updateSketchyFilter() {
        isSketchySelected.toggle()
    }

    private func updatePeopleFilter() {
        isPeopleSelected.toggle()
    }

    private func updateGeneralFilter() {
        isGeneralSelected.toggle()
    }

    private func updateAnimeFilter() {
        isAnimeSelected.toggle()
    }
}
