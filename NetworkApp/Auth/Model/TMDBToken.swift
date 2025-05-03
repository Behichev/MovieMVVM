//
//  TokenModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 21.04.2025.
//

import Foundation

struct TMDBToken: Decodable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
}
