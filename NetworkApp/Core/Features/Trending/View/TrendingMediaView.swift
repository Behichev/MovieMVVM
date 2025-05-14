//
//  TrendingMediaView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

struct TrendingMediaView: View {
    
    @StateObject private var viewModel: TrendingMediaViewModel
    
    init(repository: TMDBRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: TrendingMediaViewModel(repository: repository))
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
                    case .error(let message):
                        VStack {
                            ErrorView(errorMessage: message)
                            Spacer()
                        }
                    }
                }
        }
        .task {
            try? await viewModel.loadMedia()
        }
    }
}

//MARK: - Components

private extension TrendingMediaView {
    var mainContent: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    cells
                }
            }
            .refreshable {
                Task {
                    try? await viewModel.loadMedia()
                }
            }
            .navigationTitle("Trending")
            .padding()
        }
    }
    
    var cells: some View {
        ForEach(viewModel.media, id: \.id) { media in
            MediaPreviewCell(media: media) { url in
                try? await viewModel.setImage(url)
            } onFavoritesTapped: {
                Task {
                    try? await viewModel.favoritesToggle(media)
                }
            }
        }
    }
}
