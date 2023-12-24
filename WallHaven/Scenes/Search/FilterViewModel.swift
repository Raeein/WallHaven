import SwiftUI


class FilterViewModel: ObservableObject {
    @Published var isSFWSelected: Bool = false
    @Published var isNSFWSelected: Bool = false
    @Published var isSketchySelected: Bool = false
    @Published var isPeopleSelected: Bool = false
    @Published var isGeneralSelected: Bool = false
    @Published var isAnimeSelected: Bool = false
    @Published var query: String? = nil
    @Published var sorting: Sorting = .random
    @Published var order: Order = .desc

    @Published var configs: WallpaperConfigs

    init(configs: WallpaperConfigs) {
        self.configs = configs
        configureFilterValues()
    }

    func configureFilterValues() {
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
    
    func resetFilters() {
        configs.resetFilters()
        configureFilterValues()
    }
}

extension FilterViewModel {
    func updateSFWFilter() {
        isSFWSelected.toggle()
        configs.setSFWSelected(isSFWSelected)
    }

    func updateNSFWFilter() {
        isNSFWSelected.toggle()
        configs.setNSFWSelected(isNSFWSelected)
    }

    func updateSketchyFilter() {
        isSketchySelected.toggle()
        configs.setSketchySelected(isSketchySelected)
    }

    func updatePeopleFilter() {
        isPeopleSelected.toggle()
        configs.setPeopleSelected(isPeopleSelected)
    }

    func updateGeneralFilter() {
        isGeneralSelected.toggle()
        configs.setGeneralSelected(isGeneralSelected)
    }

    func updateAnimeFilter() {
        isAnimeSelected.toggle()
        configs.setAnimeSelected(isAnimeSelected)
    }
}
