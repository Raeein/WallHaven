import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("PREFRENCES")                               .font(.subheadline)
                    .foregroundStyle(.gray), content: {
                    HStack{
                        Image(systemName: isDarkModeEnabled ? "moon.fill" : "moon")
                            
                        Toggle(isOn: $isDarkModeEnabled) {
                            Text("Dark Mode")
//                                .font(.headline)
                        }
                    }
                    HStack{
                        NavigationLink {
                            APIKeyView()
                        } label: {
                            Text("Wall Haven API Key")
                        }
                    }
                })
            }
            .navigationTitle("Settings")
        }
    }
}



#Preview {
    SettingsView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15"))

}
