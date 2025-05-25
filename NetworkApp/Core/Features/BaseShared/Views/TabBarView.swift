//
//  TabBarView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct TabBarView: View {
    
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageLoaderService
    private let keychainService: SecureStorable
    private let repository: TMDBRepositoryProtocol
    
    @ObservedObject private var discoverViewModel: DiscoverMovieViewModel
    @ObservedObject private var favoritesViewModel: FavoritesViewModel
    @ObservedObject private var trendingViewModel: TrendingMediaViewModel
    @ObservedObject private var userViewModel: UserViewModel
    
    init(networkService: NetworkServiceProtocol,
         imageService: ImageLoaderService,
         repository: TMDBRepositoryProtocol,
         keychainService: SecureStorable) {
        self.networkService = networkService
        self.imageService = imageService
        self.repository = repository
        self.keychainService = keychainService
        
        self.discoverViewModel =  DiscoverMovieViewModel(repository: repository)
        self.trendingViewModel = TrendingMediaViewModel(repository: repository)
        self.favoritesViewModel = FavoritesViewModel(repository: repository)
        self.userViewModel = UserViewModel(repository: repository)
    }
    
    enum Assets: String {
        case trendingImageName = "chart.line.uptrend.xyaxis.circle.fill"
        case favoritesImageName = "star.circle.fill"
        case userImageName = "person.crop.circle.fill"
        case discoverImageName = "movieclapper"
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                trending
                    .navigationTitle("Trending")
                    .navigationDestination(for: Int.self) { movieID in
                        MovieDetailsView(repository: trendingViewModel.repository, movieID: movieID)
                    }
            }
            .tabItem {
                Label("Trending", systemImage: Assets.trendingImageName.rawValue)
            }
            
            NavigationStack {
                discoverMovie
                    .navigationTitle("Movies")
                    .navigationDestination(for: Int.self) { movieID in
                        MovieDetailsView(repository: discoverViewModel.repository, movieID: movieID)
                    }
            }
            .tabItem{
                Label("Movies", systemImage: Assets.discoverImageName.rawValue)
            }
            
            NavigationStack {
                favoritesMovies
                    .navigationTitle("Favorite")
                    .navigationDestination(for: Int.self) { movieID in
                        MovieDetailsView(repository: favoritesViewModel.repository, movieID: movieID)
                    }
            }
            .tabItem {
                Label("Favorites", systemImage: Assets.favoritesImageName.rawValue)
            }
            
            user
                .tabItem {
                    Label("Account", systemImage: Assets.userImageName.rawValue)
                }
        }
    }
}

private extension TabBarView {
    private var discoverMovie: some View {
        DiscoverMovieView(viewModel: discoverViewModel)
    }
    
    private var trending: some View {
        TrendingMediaView(viewModel: trendingViewModel)
    }
    
    private var favoritesMovies: some View {
        FavoritesMoviesView(viewModel: favoritesViewModel)
    }
    
    private var user: some View {
        UserView(viewModel: userViewModel)
    }
}
