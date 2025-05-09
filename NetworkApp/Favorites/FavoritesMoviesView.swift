//
//  FavoritesMoviesView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct FavoritesMoviesView: View {
    
    @StateObject var viewModel: FavoritesViewModel
    
    init(networkService: NetworkService, imageService: ImageLoaderService, keychainService: SecureStorable) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(networkService: networkService, imageService: imageService, keychainService: keychainService))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.blue)
                } else {
                    mediaListView
                }
            }
            .navigationTitle("Favorites")
        }
        .task {
            await viewModel.fetchFavorites()
        }
    }
    
    var mediaListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.favoritesMedia, id: \.id) { media in
                    MediaPreviewCell(media: media) { url in
                        await viewModel.loadImage(from: url)
                    } onFavoritesTapped: {
                        Task {
                            try await viewModel.deleteFromFavorites(media)
                        }
                    }
                }
            }
        }
    }
}
