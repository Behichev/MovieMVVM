//
//  Movie.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.05.2025.
//

import Foundation

struct Movie: Codable, Identifiable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: CollectionInfo?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var isInFavorite: Bool? = false
}

struct CollectionInfo: Codable, Hashable, Equatable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}

struct Genre: Codable, Hashable, Equatable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable, Hashable, Equatable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
}

struct ProductionCountry: Codable, Hashable, Equatable {
    let iso3166_1: String?
    let name: String
}

struct SpokenLanguage: Codable, Hashable, Equatable {
    let englishName: String
    let iso639_1: String?
    let name: String
}
