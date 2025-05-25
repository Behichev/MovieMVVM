//
//  TrendingMediaView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

struct TrendingMediaView: View {
    
    @ObservedObject var viewModel: TrendingMediaViewModel
    
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
        .refreshable {
            Task {
                try? await viewModel.loadMedia()
            }
        }
    }
    
    var cells: some View {
        ForEach(viewModel.media, id: \.id) { media in
            NavigationLink(value: media.id) {
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
}
