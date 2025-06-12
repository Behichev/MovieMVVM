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
    @ObservationIgnored var viewModel: TrendingMediaViewModel
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
        self.viewModel = TrendingMediaViewModel(repository: repository)
    }
    
    var rootView: some View  {
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
            MovieDetailsView(repository: repository, movieID: id)
        }
    }
}
