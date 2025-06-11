//
//  UserViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 11.05.2025.
//

import Foundation

@Observable
final class UserViewModel {
    
    var user: User?
    
    var avatarURL: URL? {
        guard let user else { return nil }
        
        if let path = user.avatar.tmdb.avatarPath {
            return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
        } else {
            return URL(string: "https://www.gravatar.com/avatar/\(user.avatar.gravatar.hash)?s=200&d=identicon")
        }
    }
    
    private let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUser() async throws {
        do {
            user = try await repository.fetchUser(with: Constants.APIKeys.key)
        } catch {
            throw error
        }
    }
}
