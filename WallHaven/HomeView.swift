//
//  HomeView.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-11-25.
//

import SwiftUI

struct ExecuteCode : View {
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        EmptyView()
    }
}

struct HomeView: View {
    @State private var wallpapers: Set<Wallpaper> = Set()
    
    @State private var cellWidth = 100.0
    @State private var cellHeight = 100.0
    
    @State private var columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    
    func test() {
        print("Hi")
    }
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(wallpapers.sorted(by: { $0.id < $1.id }), id: \.self) { wallpaper in
                            
                            NavigationLink {
                                ZStack {
                                    Circle()
                                        .fill(.red)
                                    AsyncImage(url: URL(string: wallpaper.path))
                                        .scaledToFit()
                                    
                                    Spacer()
                                    HStack {
                                        Text("Save")
                                        Spacer()
                                        Text("Download")
                                    }
                                }
                                
                            } label: {
                                AsyncImage(url: URL(string: wallpaper.path)) { phase in
                                    
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .frame(
                                                width: geo.size.width / 3,
                                                height: geo.size.height / 2.5
                                            )
                                            .background(.gray)
                                            .cornerRadius(8)
                                    case .failure:
                                        ExecuteCode {
                                            print(phase.error!.localizedDescription)
                                            wallpapers.remove(wallpaper)
                                        }
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaledToFill()
                                            .frame(
                                                width: geo.size.width / 3,
                                                height: geo.size.height / 2.5
                                            )                                        .clipped()
                                            .cornerRadius(8)
                                        
                                    @unknown default:
                                        fatalError()
                                    }
                                    
                                }
                            }
                        }
                        
                        
                    }
                }
                .navigationTitle("Home")
                .toolbar(content: {
                    Button {
                        print("Hi")
                    } label: {
                        Label("filter", systemImage: "line.3.horizontal.decrease")
                    }
                    .font(.largeTitle)
                })
                .task(priority: .low) {
                    do {
                        let url = URL(string: "https://wallhaven.cc/api/v1/search")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let response = try JSONDecoder().decode(WallpaperResponse.self, from: data)
                        
                        for wallpaper in response.data {
                            wallpapers.insert(wallpaper)
                        }
                    } catch  {
                        wallpapers = []
                        print(error)
                    }
                }
            }
        }
        
        

    }
}


#Preview {
    HomeView()
}
