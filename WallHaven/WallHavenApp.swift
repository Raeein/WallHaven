//
//  WallHavenApp.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-11-25.
//

import SwiftUI
import SwiftData

@main
struct WallHavenApp: App {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
//        .modelContainer(sharedModelContainer)
    }
}
