import WidgetKit


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            wallpaper: LocalImage.getSampleImages().first!
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return  SimpleEntry(
            date: Date(),
            configuration: configuration,
            wallpaper: LocalImage.getSampleImages().first!)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        let wallpapers = await APIService.shared.getWallpapers()

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = await SimpleEntry(
                date: entryDate,
                configuration: configuration,
                wallpaper: APIService.shared.loadImageFromURL(wallpaperURL: wallpapers[hourOffset].path, resizeToWidth: 800)
            )
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    
}
