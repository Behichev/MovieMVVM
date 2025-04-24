//
//  MediaList.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import Foundation

struct MediaList: Decodable {
    let page: Int
    let results: [MediaItem]
    let totalPages: Int
    let totalResults: Int
}

struct MediaItem: Codable, Identifiable {
    let id: Int
    let mediaType: MediaType
    let name: String?
    let originalName: String?
    let title: String?
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let adult: Bool
    let originalLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]?
    let firstAirDate: String?
    let releaseDate: String?
    let video: Bool?
    
    enum MediaType: String, Codable {
        case movie
        case tv
    }
}
