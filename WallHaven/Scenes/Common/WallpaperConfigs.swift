import SwiftUI

class WallpaperConfigs: ObservableObject {
    @Published var page: Int? = nil
    @Published var query: String? = nil
    @Published var topRange: TopRange = .oneYear
    @Published var sorting: Sorting = .random
    @Published var order: Order = .desc
    @Published var categories = [Category]()
    @Published var purities = [Purity]()
    
    let apiKey: String? = nil
    let isSearchView: Bool = false
    
    func addCategory(of newCategory: Category) {
        
        if !categories.contains(newCategory) {
            categories.append(newCategory)
        }
    }
    
    func getCategoryString() -> String {
        guard !categories.isEmpty else { return "000" }
        var result = ""
        
        result.append(categories.contains(.general) ? "1" : "0")
        result.append(categories.contains(.anime) ? "1" : "0")
        result.append(categories.contains(.people) ? "1" : "0")
        
        return result
    }
    
    func getPurityString() -> String {
        guard !purities.isEmpty else { return "000" }
        var result = ""
        
        result.append(purities.contains(.sfw) ? "1" : "0")
        result.append(purities.contains(.sketchy) ? "1" : "0")
        result.append(purities.contains(.nsfw) ? "1" : "0")
        
        return result
    }
    
    func getConfigsDescription() -> String {
        
        var description = "Configurations:\n"
        
        let purityString = getPurityString()
        description += "Purities: \(purityString)\n"
        
        let categoryString = getCategoryString()
        description += "Categories: \(categoryString)\n"
        
        description += "Sorting: \(sorting.rawValue), Order: \(order.rawValue)\n"
        
        if let query = query, !query.isEmpty {
            description += "Query: \(query)\n"
        }
        
        if let page = page {
            description += "Page: \(page)\n"
        }
        return description
    }
    
    func addPurity(of newPurity: Purity) {
        
        if !purities.contains(newPurity) {
            purities.append(newPurity)
        }
    }
    
    func isSFWSelected() -> Bool {
        return purities.contains(.sfw)
    }
    
    func isNSFWSelected() -> Bool {
        return purities.contains(.nsfw)
    }
    
    func isSketchySelected() -> Bool {
        return purities.contains(.sketchy)
    }
    
    func isPeopleSelected() -> Bool {
        return categories.contains(.people)
    }
    
    func isGeneralSelected() -> Bool {
        return categories.contains(.general)
    }
    
    func isAnimeSelected() -> Bool {
        return categories.contains(.anime)
    }
    
    func setSFWSelected(_ isSelected: Bool) {
        updatePurity(.sfw, isSelected: isSelected)
    }
    
    func setNSFWSelected(_ isSelected: Bool) {
        updatePurity(.nsfw, isSelected: isSelected)
    }
    
    func setSketchySelected(_ isSelected: Bool) {
        updatePurity(.sketchy, isSelected: isSelected)
    }
    
    func setPeopleSelected(_ isSelected: Bool) {
        updateCategory(.people, isSelected: isSelected)
    }
    
    func setGeneralSelected(_ isSelected: Bool) {
        updateCategory(.general, isSelected: isSelected)
    }
    
    func setAnimeSelected(_ isSelected: Bool) {
        updateCategory(.anime, isSelected: isSelected)
    }
    
    private func updatePurity(_ purity: Purity, isSelected: Bool) {
        if isSelected {
            if purities.contains(purity) == false {
                purities.append(purity)
            }
        }
        else {
            if purities.contains(purity) == false {
                purities.removeAll(where: { p in
                    purity == p
                })
            }
            
        }
    }
    private func updateCategory(_ category: Category, isSelected: Bool) {
        if isSelected {
            if categories.contains(category) == false {
                categories.append(category)
            }
        } else {
            if categories.contains(category) {
                categories.removeAll(where: { c in
                    category == c
                })
            }
            
        }
    }
    
    func resetFilters() {
        purities.removeAll()
        categories.removeAll()
        sorting = .random
        order = .desc
        topRange = .oneYear
    }
}
