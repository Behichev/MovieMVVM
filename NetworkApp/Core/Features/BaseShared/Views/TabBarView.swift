//
//  TabBarView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct TabBarView: View {

    @Bindable var tabBarCoordinator: TabBarCoordinator
    
    @Bindable var trendingCoordinator: TrendingCoordinator
    @Bindable var discoverCoordinator: DiscoverCoordinator
    @Bindable var favoritesCoordinator: FavoritesCoordinator
    
    let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorageProtocol, tabBarCoordinator: TabBarCoordinator) {
        self.repository = repository
        self.tabBarCoordinator = tabBarCoordinator
        self.trendingCoordinator = TrendingCoordinator(repository: repository, mediaStorage: mediaStorage)
        self.discoverCoordinator = DiscoverCoordinator(repository: repository, moviesStorage: mediaStorage)
        self.favoritesCoordinator = FavoritesCoordinator(repository: repository, mediaStorage: mediaStorage)
    }
    
    enum Assets: String {
        case trendingImageName = "chart.line.uptrend.xyaxis.circle.fill"
        case favoritesImageName = "star.circle.fill"
        case userImageName = "person.crop.circle.fill"
        case discoverImageName = "movieclapper"
    }
    
    var body: some View {
        TabView(selection: $tabBarCoordinator.selectedTab) {
            
            tabBarCoordinator.trendingTab
                .tabItem {
                    Label("Trending", systemImage: Assets.trendingImageName.rawValue)
                }
                .tag(TabBarItem.trending)

            tabBarCoordinator.discoverTab
                .tabItem {
                    Label("Movies", systemImage: Assets.discoverImageName.rawValue)
                }
                .tag(TabBarItem.discovery)

            tabBarCoordinator.favoritesTab
                .tabItem {
                    Label("Favorites", systemImage: Assets.favoritesImageName.rawValue)
                }
                .tag(TabBarItem.favorite)
            
            tabBarCoordinator.userTab
                .tabItem {
                    Label("Profile", systemImage: Assets.userImageName.rawValue)
                }
                .tag(TabBarItem.userProfile)
        }
        .onAppear {
            tabBarCoordinator.trendingCoordinator = trendingCoordinator
            tabBarCoordinator.discoverCoordinator = discoverCoordinator
            tabBarCoordinator.favoritesCoordinator = favoritesCoordinator
        }
    }
}
