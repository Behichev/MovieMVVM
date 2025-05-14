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
    private let keychainService: SecureStorable
    private let repository: TMDBRepositoryProtocol
    
    init(networkService: NetworkService, imageService: ImageLoaderService, repository: TMDBRepositoryProtocol, keychainService: SecureStorable) {
        self.networkService = networkService
        self.imageService = imageService
        self.repository = repository
        self.keychainService = keychainService
    }
    
    enum Assets: String {
        case trendingImageName = "chart.line.uptrend.xyaxis.circle.fill"
        case favoritesImageName = "star.circle.fill"
        case userImageName = "person.crop.circle.fill"
    }
    
    var body: some View {
        TabView {
            TrendingMediaView(repository: repository)
                .tabItem {
                    Label("Tranding", systemImage: Assets.trendingImageName.rawValue)
                }
                
            FavoritesMoviesView(repository: repository)
                .tabItem {
                    Label("Favorites", systemImage: Assets.favoritesImageName.rawValue)
                }
            
            UserView(repository: repository)
                .tabItem {
                    Label("Account", systemImage: Assets.userImageName.rawValue)
                }
        }
    }
}
