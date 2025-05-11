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
    private let trendingRepository: TrendingMediaRepository
    private let keychainService: SecureStorable
    private let favoritesRepository: FavoritesMediaRepository
    private let userRepository: UserRepository
    
    init(networkService: NetworkService, imageService: ImageLoaderService, trendingRepository: TrendingMediaRepository, keychainService: SecureStorable, favoritesRepository: FavoritesMediaRepository, userRepository: UserRepository) {
        self.networkService = networkService
        self.imageService = imageService
        self.trendingRepository = trendingRepository
        self.keychainService = keychainService
        self.favoritesRepository = favoritesRepository
        self.userRepository = userRepository
    }
    
    var body: some View {
        TabView {
            TrendingMediaView(repository: trendingRepository)
                .tabItem {
                    Label("Tranding", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                }
                
            FavoritesMoviesView(repository: favoritesRepository)
                .tabItem {
                    Label("Favorites", systemImage: "star.circle.fill")
                }
            
            UserView(repository: userRepository)
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}
