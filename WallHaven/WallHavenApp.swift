//
//  WallHavenApp.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-11-25.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct WallHavenApp: App {

    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SearchItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .animation(.smooth, value: isDarkModeEnabled)
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
                    .task {
                        try? Tips.resetDatastore()
                        try? Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
            
//            
//                .task {
//                    try? Tips.configure([
//                        .displayFrequency(.weekly),
//                        .datastoreLocation(.applicationDefault)
//                    ])
//                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func adjustVisualAppearance() {
        var navigationBarLayoutMargins: UIEdgeInsets = .zero
        navigationBarLayoutMargins.left = 26.0
        navigationBarLayoutMargins.right = navigationBarLayoutMargins.left
        UINavigationBar.appearance().layoutMargins = navigationBarLayoutMargins

        var tableViewLayoutMargins: UIEdgeInsets = .zero
        tableViewLayoutMargins.left = 28.0
        tableViewLayoutMargins.right = tableViewLayoutMargins.left
        UITableView.appearance().layoutMargins = tableViewLayoutMargins
    }
}
