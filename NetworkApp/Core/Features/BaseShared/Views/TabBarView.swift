//
//  TabBarView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

enum Pages: Hashable {
    case trending
    case favorites
    case discover
    case userProfile
    case movie(movieID: Int)
}

@MainActor
class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    var repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    func push(_ page: Pages) {
        path.append(page)
    }
    
    func pop() {
        print("before ----: \(path)")
        path.removeLast()
        print("after ----: \(path)")
    }
    
    @ViewBuilder
    func build(_ page: Pages) -> some View {
        switch page {
        case .trending:
            TrendingMediaView(viewModel: TrendingMediaViewModel(repository: repository))
        case .favorites:
            FavoritesMoviesView(viewModel: FavoritesViewModel(repository: repository))
        case .discover:
            DiscoverMovieView(viewModel: DiscoverMovieViewModel(repository: self.repository))
        case .userProfile:
            UserView(viewModel: UserViewModel(repository: repository))
        case .movie(let movieID):
            MovieDetailsView(repository: repository, movieID: movieID)
        }
    }
}

struct TabBarView: View {
    
    @ObservedObject var trendingCoordinator: Coordinator
    @ObservedObject var discoverCoordinator: Coordinator
    @ObservedObject var favoritesCoordinator: Coordinator
    
    private let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
        
        _trendingCoordinator = ObservedObject(wrappedValue: Coordinator(repository: repository))
        _discoverCoordinator = ObservedObject(wrappedValue: Coordinator(repository: repository))
        _favoritesCoordinator = ObservedObject(wrappedValue: Coordinator(repository: repository))
    }
    
    enum Assets: String {
        case trendingImageName = "chart.line.uptrend.xyaxis.circle.fill"
        case favoritesImageName = "star.circle.fill"
        case userImageName = "person.crop.circle.fill"
        case discoverImageName = "movieclapper"
    }
    
    var body: some View {
        TabView {
    
            trending
                .navigationTitle("Trending")
                .tabItem {
                    Label("Trending", systemImage: Assets.trendingImageName.rawValue)
                }
            
            discoverMovie
                .navigationTitle("Movies")
                .tabItem {
                    Label("Movies", systemImage: Assets.discoverImageName.rawValue)
                }
            
            favoritesMovies
                .navigationTitle("Favorites")
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
        NavigationStack(path: $discoverCoordinator.path) {
            discoverCoordinator.build(.discover)
                .navigationDestination(for: Pages.self) { page in
                    discoverCoordinator.build(page)
                }
        }
        .onChange(of: discoverCoordinator.path) { newValue in
            print("🌀 path changed:", newValue)
        }
        .environmentObject(discoverCoordinator)
        
    }
    
    private var trending: some View {
        NavigationStack(path: $trendingCoordinator.path) {
            trendingCoordinator.build(.trending)
                .navigationDestination(for: Pages.self) { page in
                    trendingCoordinator.build(page)
                }
        }
        .environmentObject(trendingCoordinator)
    }
    
    private var favoritesMovies: some View {
        NavigationStack(path: $favoritesCoordinator.path) {
            favoritesCoordinator.build(.favorites)
                .navigationDestination(for: Pages.self) { page in
                    favoritesCoordinator.build(page)
                }
        }
        .environmentObject(favoritesCoordinator)
    }
    
    private var user: some View {
       UserView(viewModel: UserViewModel(repository: repository))
    }
}
