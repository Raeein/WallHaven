//
//  HomeScreenWallpaperPreview.swift
//  WallHaven
//
//  Created by Raeein Bagheri on 2023-12-11.
//

import SwiftUI

struct HomeScreenWallpaperPreview: View {
    var wallpaperImage: Image // Your wallpaper image
    
    var body: some View {
        ZStack {
            // Wallpaper Image
            wallpaperImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Simulated App Icons at the bottom
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { _ in
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 30) // Same as typical iOS dock padding
            }
        }
    }
}

#Preview {
    HomeScreenWallpaperPreview(wallpaperImage: Image(systemName: "gear"))
}
