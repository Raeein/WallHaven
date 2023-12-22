import ActivityKit
import WidgetKit
import SwiftUI

struct WallHaven_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
    }

    var name: String
}

struct WallHaven_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WallHaven_WidgetAttributes.self) { context in
            
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {

                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WallHaven_WidgetAttributes {
    fileprivate static var preview: WallHaven_WidgetAttributes {
        WallHaven_WidgetAttributes(name: "World")
    }
}

extension WallHaven_WidgetAttributes.ContentState {
    fileprivate static var smiley: WallHaven_WidgetAttributes.ContentState {
        WallHaven_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WallHaven_WidgetAttributes.ContentState {
         WallHaven_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WallHaven_WidgetAttributes.preview) {
   WallHaven_WidgetLiveActivity()
} contentStates: {
    WallHaven_WidgetAttributes.ContentState.smiley
    WallHaven_WidgetAttributes.ContentState.starEyes
}
