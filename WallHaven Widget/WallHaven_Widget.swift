import WidgetKit
import SwiftUI

struct WallHaven_Widget: Widget {
    let kind: String = "WallHaven_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    WallHaven_Widget()
    
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, wallpaper: LocalImage.getSampleImages().first!)
    SimpleEntry(date: .now, configuration: .starEyes, wallpaper: LocalImage.getSampleImages().first!)
}

#Preview(as: .systemLarge) {
    WallHaven_Widget()
    
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, wallpaper: LocalImage.getSampleImages().first!)
    SimpleEntry(date: .now, configuration: .starEyes, wallpaper: LocalImage.getSampleImages().first!)
}
