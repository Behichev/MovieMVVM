//
//  TabBarCoordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

enum TabBarItem {
    case trending
    case discovery
    case favorite
    case userProfile
}
@Observable
final class TabBarCoordinator {
    
    var selectedTab: TabBarItem = .trending
    
    @ObservationIgnored var trendingCoordinator: TrendingCoordinator?
    @ObservationIgnored var discoverCoordinator: DiscoverCoordinator?
    @ObservationIgnored var favoritesCoordinator: FavoritesCoordinator?
    
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    var mediaStorage: MoviesStorageProtocol
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorageProtocol) {
        self.repository = repository
        self.mediaStorage = mediaStorage
        setupCoordinators()
    }
    
    var rootView: some View {
        TabBarView(repository: repository, mediaStorage: mediaStorage, tabBarCoordinator: self)
    }
    
    func selectTab(tab: TabBarItem) {
        if selectedTab == tab {
            coordinator(for: selectedTab)?.closeAllChild()
        } else {
            switch tab {
            case .trending, .discovery, .favorite, .userProfile:
                selectedTab = tab
            }
        }
    }
    
    @MainActor
    var discoverTab: some View {
        if discoverCoordinator == nil {
            discoverCoordinator = DiscoverCoordinator(repository: repository, moviesStorage: mediaStorage)
        }
        return DiscoverCoordinatorView(coordinator: discoverCoordinator!)
    }
    
    @MainActor
    var trendingTab: some View {
        if trendingCoordinator == nil {
            trendingCoordinator = TrendingCoordinator(repository: repository, mediaStorage: mediaStorage)
        }
        return TrendingCoordinatorView(coordinator: trendingCoordinator!)
    }
    
    @MainActor
    var favoritesTab: some View {
        if favoritesCoordinator == nil {
            favoritesCoordinator = FavoritesCoordinator(repository: repository, mediaStorage: mediaStorage)
        }
        return FavoritesRootView(coordinator: favoritesCoordinator!)
    }
    
    @MainActor
    var userTab: some View {
        UserView(viewModel: UserViewModel(repository: repository))
    }
    
    private func setupCoordinators() {
        favoritesCoordinator = FavoritesCoordinator(repository: repository, mediaStorage: mediaStorage)
        discoverCoordinator = DiscoverCoordinator(repository: repository, moviesStorage: mediaStorage)
        trendingCoordinator = TrendingCoordinator(repository: repository, mediaStorage: mediaStorage)
    }
    
    private func coordinator(for selectedTab: TabBarItem) -> (any Coordinator)? {
        switch selectedTab {
        case .trending:
            return trendingCoordinator
        case .discovery:
            return discoverCoordinator
        case .favorite:
            return favoritesCoordinator
        case .userProfile:
            return nil
        }
    }
}
