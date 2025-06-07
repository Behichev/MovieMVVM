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

final class DiscoverCoordinator: Coordinator {
    
    @Published var path = NavigationPath()
    
    let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    var rootView: some View  {
        let viewModel = DiscoverMovieViewModel(repository: repository)
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
            MovieDetailsView(repository: repository, movieID: id)
        }
    }
}
