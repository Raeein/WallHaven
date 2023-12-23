import Foundation
import SwiftData

@Model
final class SearchItem {
    var searchText: String
    var timestamp: Date

    init(searchText: String, timestamp: Date) {
        self.timestamp = timestamp
        self.searchText = searchText
    }
}
