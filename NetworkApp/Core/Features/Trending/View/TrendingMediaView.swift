//
//  TrendingMediaView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

struct TrendingMediaView: View {
    
    @ObservedObject var viewModel: TrendingMediaViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .tint(.accentColor)
            case .success:
                mainContent
                    .padding()
            }
        }
        .refreshable {
            Task {
                try? await viewModel.loadMedia()
            }
        }
        .task {
            if !viewModel.isLoaded {
                try? await viewModel.loadMedia()
            }
        }
    }
}

//MARK: - Components

private extension TrendingMediaView {
    var mainContent: some View {
        LazyVStack {
            cells
                .buttonStyle(.plain)
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
            .onTapGesture {
                coordinator.push(.movie(movieID: media.id))
            }
        }
    }
}
