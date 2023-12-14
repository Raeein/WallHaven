import SwiftUI


enum ImageQuality: String, CaseIterable, Identifiable {
    case high = "High"
    case low = "Low"
    var id: String { self.rawValue }
}

struct SettingsView: View {
    
    @AppStorage("imageQuality") private var imageQuality: ImageQuality = .low
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    @AppStorage("isSensoryFeedbackEnabled") private var isSensoryFeedbackEnabled = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("PREFRENCES")                               .font(.subheadline)
                    .foregroundColor(.secondary), content: {
                        HStack{
                            Image(systemName: isDarkModeEnabled ? "moon.fill" : "moon")
                            
                            Toggle(isOn: $isDarkModeEnabled) {
                                Text("Dark Mode")
                            }
                            
                        }
                        Toggle(isOn: $isSensoryFeedbackEnabled) {
                            Text("Vibrate")
                            Text("Vibrate when image is succesfully downloaded")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            
                        }
                        
                        HStack{
                            NavigationLink {
                                APIKeyView()
                            } label: {
                                Text("Wall Haven API Key")
                            }
                        }
                        Picker("Image Quality", systemImage: "photo.circle.fill", selection: $imageQuality) {
                            ForEach(ImageQuality.allCases) { iq in
                                Text(iq.rawValue).tag(iq)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        NavigationLink {
                            LottieView(animationName: "dizzy")
                        } label: {
                            Text("Make me dizzy")
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
