import TipKit

import Foundation

struct FilterTip: Tip {
    var title: Text {
        Text("Filter")
    }

    var message: Text? {
        Text("Add filter to the photos")
    }

    var rules: [Rule] {
        #Rule(Self.$hasViewedRefreshTip) { $0 == true }
    }

    @Parameter
    static var hasViewedRefreshTip: Bool = false
    //        var image: Image? {
    //        Image(systemName: "heart")
    //    }
}

struct RefreshTip: Tip {
    var title: Text {
        Text("Refresh")
    }

    var message: Text? {
        Text("Tap on to refresh the photos")
    }
}
