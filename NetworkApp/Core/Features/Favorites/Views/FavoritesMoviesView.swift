//
//  FavoritesMoviesView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct FavoritesMoviesView: View {
    
    @StateObject var viewModel: FavoritesViewModel
    
    init(repository: FavoritesMediaRepository) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(repository: repository))
    }
    
    var body: some View {
        Group {
            mainContent
                .overlay {
                    switch viewModel.viewState {
                    case .loading:
                        LoaderView()
                    case .success:
                        EmptyView()
                    case .error(let errorMessage):
                        VStack {
                            ErrorView(errorMessage: errorMessage)
                            Spacer()
                        }
                    }
                }
        }
        .task {
            try? await viewModel.fetchFavorites()
        }
    }
}

//MARK: - Components

private extension FavoritesMoviesView {
    
    var mainContent: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    cells
                }
            }
            .padding()
            .refreshable {
                Task {
                    try? await viewModel.fetchFavorites()
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    var cells: some View {
        ForEach(viewModel.favoritesMedia, id: \.id) { media in
            MediaPreviewCell(media: media) { url in
                try? await viewModel.setImage(url)
            } onFavoritesTapped: {
                Task {
                    try? await viewModel.removeFromFavorites(media)
                }
            }
        }
    }
}
