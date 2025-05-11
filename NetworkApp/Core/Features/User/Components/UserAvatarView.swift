//
//  UserAvatarView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 11.05.2025.
//

import SwiftUI

struct UserAvatarView: View {
    let url: URL?
    let size: CGFloat

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .shadow(radius: 4)
    }

    private var placeholderImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .foregroundColor(.gray.opacity(0.4))
    }
}
