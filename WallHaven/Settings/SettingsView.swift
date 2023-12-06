//
//  SettingsView.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-12-05.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("PREFRENCES"), content: {
                    HStack{
                        Image(systemName: isDarkModeEnabled ? "moon.fill" : "moon")
                        Toggle(isOn: $isDarkModeEnabled) {
                            Text("Dark Mode")
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
}
