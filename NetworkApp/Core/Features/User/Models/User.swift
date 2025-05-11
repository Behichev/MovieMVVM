//
//  User.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

struct User: Codable {
    let avatar: Avatar
    let id: Int
    let iso6391: String
    let iso31661: String
    let name: String
    let includeAdult: Bool
    let username: String
}

struct Avatar: Codable {
    let gravatar: Gravatar
    let tmdb: Tmdb
}

struct Gravatar: Codable {
    let hash: String
}

struct Tmdb: Codable {
    let avatarPath: String?
}
