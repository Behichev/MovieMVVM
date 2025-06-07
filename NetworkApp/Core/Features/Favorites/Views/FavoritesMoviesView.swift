//
//  FavoritesMoviesView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct FavoritesMoviesView: View {
    
    @StateObject var viewModel: FavoritesViewModel
    let onMediaTapped: (Int) -> Void
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .tint(.accentColor)
            case .success:
                if viewModel.favoritesMedia.isEmpty {
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.primary)
                        Text("Favorites is empty")
                    }
                } else {
                    mainContent
                }
            }
        }
        .task {
            if !viewModel.isLoaded {
                try? await viewModel.fetchFavorites()
            }
        }
    }
}

//MARK: - Components

private extension FavoritesMoviesView {
    
    var mainContent: some View {
            ScrollView {
                LazyVStack {
                    cells
                }
            }
            .navigationTitle("Favorites")
            .padding()
            .refreshable {
                Task {
                    try? await viewModel.fetchFavorites()
                }
            }
    }
    
    var cells: some View {
        ForEach(viewModel.favoritesMedia, id: \.id) { media in
                createCell(with: media)
                .onTapGesture {
                    onMediaTapped(media.id)
                }
        }
    }
    
    @ViewBuilder
    private func createCell(with mediaItem: MediaItem) -> some View {
        MediaPreviewCell(media: mediaItem) { url in
            try? await viewModel.setImage(url)
        } onFavoritesTapped: {
            Task {
                try? await viewModel.removeFromFavorites(mediaItem)
            }
        }
        
    }
}
