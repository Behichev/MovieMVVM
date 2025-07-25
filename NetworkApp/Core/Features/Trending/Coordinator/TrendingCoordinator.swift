//
//  TrendingCoordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 05.06.2025.
//

import SwiftUI

enum TrendingCoordinatorPages: Hashable {
    case details(id: Int)
}

@Observable
final class TrendingCoordinator: Coordinator {
    
    var path = NavigationPath()
    
    @ObservationIgnored let repository: TMDBRepositoryProtocol
    var mediaStorage: MoviesStorageProtocol
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorageProtocol) {
        self.repository = repository
        self.mediaStorage = mediaStorage
    }
    
    var rootView: some View  {
        let viewModel = TrendingMediaViewModel(repository: repository, mediaStorage: mediaStorage)
        TrendingMediaView(viewModel: viewModel, onMediaTapped: { id in
            self.push(.details(id: id))
        })
    }
    
    func push(_ page: TrendingCoordinatorPages) {
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
    func build(_ page: TrendingCoordinatorPages) -> some View {
        switch page {
        case .details(let id):
            MovieDetailsView(repository: repository, movieStorage: mediaStorage, movieID: id)
        }
    }
}
