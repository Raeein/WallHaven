import WidgetKit
import SwiftUI
  

struct MediumSizeView: View {
    var entry: SimpleEntry

    var body: some View {
        
        GroupBox {
            HStack {
                if let image = entry.wallpaper {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                }
                Spacer()
            }
        } label: {
            Label("Wallpaper", systemImage: "list.dash")
        }
        .padding()
    }
}
 
struct LargeSizeView: View {
    var entry: SimpleEntry
    
    var body: some View {
        GroupBox {
            HStack {
                if let image = entry.wallpaper {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                }
                Spacer()
            }
        } label: {
            Label("Wallpaper", systemImage: "list.dash")
        }
        .padding()
    }
}
    
    


struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: SimpleEntry

    var body: some View {
        
        switch widgetFamily {
        case .systemMedium:
            MediumSizeView(entry: entry)
        case .systemLarge:
            LargeSizeView(entry: entry)
        default:
            Text("Not implemented!")
        }
    }
}
 
