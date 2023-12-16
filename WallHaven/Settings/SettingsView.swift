import SwiftUI
import Lottie


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
                            .tint(.blue)
                            
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
                        
       
                    })
                
                Section {
                    Toggle(isOn: $isSensoryFeedbackEnabled) {
                        Text("Vibrate")
                    }
                    .tint(.blue)
                } footer: {
                    Text("Vibrate phone when image is saved to photos.")
                }
                
                
                Section {
                    NavigationLink {
                        LottieView(animation: .named(Constants.Lottie.dizzy))
                            .playing(loopMode: .loop)
                    } label: {
                        Text("Make me dizzy")
                    }
                } footer: {
                    Text("Completely unnecessary...just a bored out of mind fellow dev!")
                }

        
            }
            .navigationTitle("Settings")
        }
    }
}



#Preview {
    SettingsView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15"))
    
}
