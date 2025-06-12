//
//  MovieDetailsView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.05.2025.
//

import SwiftUI

struct MovieDetailsView: View {
    
    @Bindable private var viewModel: MovieDetailsViewModel
    @State private var image: UIImage?
    
    init(repository: TMDBRepositoryProtocol, movieID: Int) {
        _viewModel = Bindable(wrappedValue: MovieDetailsViewModel(repository: repository, movieID: movieID))
    }
    
    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .cornerRadius(Constants.Design.LayoutConstants.cornerRadius.rawValue)
            }
            Text(viewModel.movie?.title ?? "No Title")
                .font(.largeTitle)
                .bold()
            Text(viewModel.movie?.overview ?? "")
            Text("Budget: \(viewModel.movie?.budget ?? 0)")
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Кнопка натиснута")
                }) {
                    Image(systemName: "star")
                }
            }
        }
        
        .task {
            try? await viewModel.getMovieDetails()
            if let imagePath = viewModel.movie?.posterPath {
                image = try? await viewModel.setImage(imagePath)
            }
        }
    }
}

#Preview {
    let repo = TMDBRepository(networkService: NetworkService(),imageService: TMDBImageLoader(), keychainService: KeychainService(),dataSource: MoviesStorage(), errorManager: ErrorManager())
    MovieDetailsView(repository: repo, movieID: 12)
}
