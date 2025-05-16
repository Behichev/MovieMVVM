//
//  MediaPreviewCell.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 18.04.2025.
//

import SwiftUI

struct MediaPreviewCell: View {
    
    let media: MediaItem
    let loadPoster: (String) async -> UIImage?
    let onFavoritesTapped: () -> ()
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110)
                        .cornerRadius(Constants.Design.LayoutConstants.cornerRadius.rawValue)
                } else {
                    skeletonImageView
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text(media.name ?? media.title ?? "No title")
                            .font(.headline.bold())
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                onFavoritesTapped()
                            }
                        } label: {
                            Image(systemName: media.isInFavorites ?? false ? "star.fill" : "star")
                        }
                    }
                    .foregroundStyle(.primary)
                    
                    HStack() {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(media.releaseDate?.formattedDate() ?? media.firstAirDate?.formattedDate() ?? "")
                            .font(.footnote)
                        Spacer()
                    }
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(media.overview)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    
                    Spacer()
                }
                
                Spacer()
                
                
                
            }
        }
        .task {
            if image == nil {
                image = await loadPoster(media.posterPath ?? "")
            }
        }
    }
    
    var skeletonImageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.gray)
                .frame(width: 110, height: 170)
            ProgressView()
                .tint(.yellow)
        }
    }
}
