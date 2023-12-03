//
//  HomeView.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-11-25.
//

import SwiftUI

struct HomeView: View {
    @State private var wallpapers = [Wallpaper]()
    
    @State private var cellSize = 100.0
    
    @State private var columns = [
        GridItem(.fixed(cellSize), spacing: 1),
        GridItem(.fixed(cellSize), spacing: 1),
        GridItem(.fixed(cellSize), spacing: 1),
    ]
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(wallpapers, id: \.self) { wallpaper in
                            AsyncImage(url: URL(string: wallpaper.path)) { phase in
                            
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: 100, height: 200)
                                case .failure:
                                    Text(phase.error!.localizedDescription)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFill()
                                        .frame(width: 100, height: 200)
                                        .clipped()
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
                        wallpapers.append(wallpaper)
                    }
                } catch  {
                    wallpapers = []
                    print(error)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
