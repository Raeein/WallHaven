import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Wallpapers"
    static var description = IntentDescription("View random wallpapers.")

    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
