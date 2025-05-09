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
    private let trendingRepository: MediaRepository
    private let keychainService: SecureStorable
    
    init(networkService: NetworkService, imageService: ImageLoaderService, trendingRepository: MediaRepository, keychainService: SecureStorable) {
        self.networkService = networkService
        self.imageService = imageService
        self.trendingRepository = trendingRepository
        self.keychainService = keychainService
    }
    
    var body: some View {
        TabView {
            TrendingMediaView(repository: trendingRepository)
                .tabItem {
                    Label("Tranding", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                }
                
            FavoritesMoviesView(networkService: networkService, imageService: imageService, keychainService: keychainService)
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
