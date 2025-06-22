//
//  DiscoverCoordinatorPages.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

enum FavoritesCoordinatorPages: Hashable {
    case details(id: Int)
}

@Observable
final class FavoritesCoordinator: Coordinator {
    
    var path = NavigationPath()
    
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    @ObservationIgnored var viewModel: FavoritesViewModel
    private var mediaStorage: MoviesStorageProtocol
 
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorage) {
        self.repository = repository
        self.mediaStorage = mediaStorage
        self.viewModel = FavoritesViewModel(repository: repository, mediaStorage: mediaStorage)
    }
    
    var rootView: some View  {
        FavoritesMoviesView(viewModel: viewModel, onMediaTapped: { id in
            self.push(.details(id: id))
        })
    }
    
    func push(_ page: FavoritesCoordinatorPages) {
        path.append(page)
    }
    
    func pop(_ last: Int = 1) {
        path.removeLast(last)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func closeAllChild() {
            path = NavigationPath()
        }
    
    @ViewBuilder
    func build(_ page: FavoritesCoordinatorPages) -> some View {
        switch page {
        case .details(let id):
            MovieDetailsView(repository: repository, movieStorage: mediaStorage, movieID: id)
        }
    }
}
