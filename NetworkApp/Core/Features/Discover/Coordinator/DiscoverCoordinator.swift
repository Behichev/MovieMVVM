//
//  DiscoverCoordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

enum DiscoverCoordinatorPages: Hashable {
    case details(id: Int)
}

@Observable
final class DiscoverCoordinator: Coordinator {
    
    var path = NavigationPath()
    var moviesStorage: MoviesStorageProtocol
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    @ObservationIgnored var viewModel: DiscoverMovieViewModel
    
    init(repository: TMDBRepositoryProtocol, moviesStorage: MoviesStorageProtocol) {
        self.repository = repository
        self.moviesStorage = moviesStorage
        self.viewModel = DiscoverMovieViewModel(repository: repository, movieStorage: moviesStorage)
    }
    
    var rootView: some View  {
        DiscoverMovieView(viewModel: viewModel, onMediaTapped: { id in
            self.push(.details(id: id))
        })
    }
    
    func push(_ page: DiscoverCoordinatorPages) {
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
    func build(_ page: DiscoverCoordinatorPages) -> some View {
        switch page {
        case .details(let id):
            MovieDetailsView(repository: repository, movieStorage: moviesStorage, movieID: id)
        }
    }
}
