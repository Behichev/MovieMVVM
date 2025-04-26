//
//  MediaContentCell.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 18.04.2025.
//

import SwiftUI

struct MediaContentCell: View {
    
    let viewModel: TrendingMediaViewModel
    let media: MediaItem
    let addToFavorites: () -> ()
    
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110)
                    .cornerRadius(12)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 180)
                    ProgressView()
                        .tint(.yellow)
                }
            }
            
            VStack(alignment: .leading) {
                Text(media.name ?? media.title ?? "No title")
                    .font(.headline.bold())
                    
                Text(media.originalName ?? media.originalTitle ?? "No original title")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Text(media.releaseDate ?? media.firstAirDate ?? "")
                    .font(.footnote)
                
                Spacer()
            }
            
            Spacer()
            
            Button("Add to favorites") {
                addToFavorites()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .task {
            if image == nil {
                image = await viewModel.loadImage(from: media.posterPath ?? "")
            }
        }
    }
}


