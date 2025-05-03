//
//  TabBarView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct TabBarView: View {
    
    private let networkService: NetworkService
    private let imageService: ImageLoaderService
    
    init(networkService: NetworkService, imageService: ImageLoaderService) {
        self.networkService = networkService
        self.imageService = imageService
    }
    
    var body: some View {
        TabView {
            TrendingMediaView(networkService: networkService, imageService: imageService)
                .tabItem {
                    Label("Tranding", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                }
                
            FavoritesMoviesView(networkService: networkService, imageService: imageService)
                .tabItem {
                    Label("Favorites", systemImage: "star.circle.fill")
                }
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    TabBarView(networkService: NetworkLayer(), imageService: TMDBImageLoader())
}
