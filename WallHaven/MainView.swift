//
//  MainView.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-11-25.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(1)

            Text("Tab Content 2")
                .tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
        })
        .background(.black)
        .foregroundStyle(.black)
        .font(.system(size: 22))

    }
}

#Preview {
    MainView()
}
