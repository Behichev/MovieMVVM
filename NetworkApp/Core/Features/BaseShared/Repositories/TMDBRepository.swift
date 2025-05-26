//
//  TMDBRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

final class TMDBRepository: TMDBRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageLoaderService
    private let keychainService: SecureStorable
    private let userID: String
    
    private var errorManager: ErrorManager
    private var authEndpoint: AuthEndpoint?
    private var token: TMDBToken?
    
    private var dataSource: MoviesStorageProtocol
    
    init(networkService: NetworkServiceProtocol,
         imageService: ImageLoaderService,
         keychainService: SecureStorable,
         dataSource: MoviesStorageProtocol,
         errorManager: ErrorManager) {
        self.networkService = networkService
        self.imageService = imageService
        self.keychainService = keychainService
        self.dataSource = dataSource
        self.errorManager = errorManager
        
        userID = String(keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? 0)
    }
    
    func setErrorManager(_ errorManager: ErrorManager) {
        self.errorManager = errorManager
    }
    //MARK: - Authorization
    func requestToken() async throws {
        do {
            authEndpoint = .newToken(apiKey: Constants.APIKeys.token)
            guard let authEndpoint else { return }
            token = try await networkService.performRequest(from: authEndpoint)
        } catch {
            throw error
        }
    }
    
    func userAuthorization(with credentials: Credentials) async throws {
        authEndpoint = .validateWithLogin(apiKey: Constants.APIKeys.token, requestToken: token?.requestToken ?? "", credentials: credentials)
        guard let authEndpoint else { return }
        do {
            try await networkService.performPostRequest(from: authEndpoint)
        } catch let authError as NetworkError {
            await errorManager.showError(authError.localizedDescription)
            throw NetworkError.invalidCredentials
        } catch {
            await errorManager.showError("\(NetworkError.invalidCredentials.localizedDescription)")
            throw error
        }
    }
    
    func createSession() async throws {
        authEndpoint = .newSession(apiKey: Constants.APIKeys.token, sessionID: token?.requestToken ?? "")
        guard let authEndpoint else { return }
        do {
            let token: SessionModel = try await networkService.performRequest(from: authEndpoint)
            keychainService.save(token.sessionId, forKey: Constants.KeychainKeys.session.rawValue)
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws {
        authEndpoint = .deleteUser(apiKey: apiKey, sessionID: sessionID)
        guard let authEndpoint else { return }
        do {
            try await networkService.performPostRequest(from: authEndpoint)
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser(with apiKey: String) async throws -> User {
        let sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        authEndpoint = .validation(apiKey: apiKey, sessionID: sessionID)
        guard let authEndpoint else { throw URLError(.badURL) }
        do {
            let user: User = try await networkService.performRequest(from: authEndpoint)
            keychainService.save(user.id, forKey: Constants.KeychainKeys.userID.rawValue)
            return user
        } catch {
            throw error
        }
    }
  //MARK: - Movies/Shows
    func fetchTrendingMedia() async throws -> [MediaItem] {
        do {
            let localMedia = dataSource.getTrendingMovies()
            
            let mediaResult: MediaResult = try await networkService.performRequest(from: MediaEndpoint.trending(mediaItem: .movie, timeWindow: TimeWindow.day.rawValue))
            var mediaList = mediaResult.results
            
            let favoriteMedia = try await fetchFavoritesMovies()
            
            for item in favoriteMedia {
                if let index = mediaList.firstIndex(where: {$0.id == item.id }) {
                    mediaList[index].isInFavorites = true
                }
            }
            
            if localMedia != mediaList {
                dataSource.saveTrendingMovies(mediaList)
                return mediaList
            } else {
                return localMedia
            }
            
        } catch {
            let localMedia = dataSource.getTrendingMovies()
            return localMedia
        }
    }
    
    func fetchFavoritesMovies() async throws -> [MediaItem] {
        do {
            let mediaResult: MediaResult = try await networkService.performRequest(from: MediaEndpoint.favoriteMovies(accountId: userID))
            var favoriteMediaList = mediaResult.results
            let favoritesMediaListLocal = dataSource.getTrendingMovies()
            
            for (index, _) in favoriteMediaList.enumerated() {
                favoriteMediaList[index].isInFavorites = true
            }
            
            if favoritesMediaListLocal != favoriteMediaList {
                dataSource.saveFavoriteMovies(favoriteMediaList)
                return favoriteMediaList
            } else {
                return favoritesMediaListLocal
            }
            
        } catch {
            throw error
        }
    }
    
    func addMovieToFavorite(_ item: MediaItem) async throws {
        do {
            try await networkService.performPostRequest(from: MediaEndpoint.addToFavorites(accountId: userID, item: item))
            dataSource.addToFavorites(item)
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteMovieFromFavorites(_ item: MediaItem) async throws {
        do {
            var deletedItem = item
            deletedItem.mediaType = .movie
            try await networkService.performPostRequest(from: MediaEndpoint.removeFromFavorites(accountId: userID, item: deletedItem))
            dataSource.removeFromFavorites(item)
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
            throw error
        }
    }
    
    func favoritesToggle(_ item: MediaItem) async throws {
        do {
            if item.isInFavorites ?? false {
                try await deleteMovieFromFavorites(item)
            } else {
                try await addMovieToFavorite(item)
            }
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
        }
    }
    
    func fetchMovieList(page: Int) async throws -> [MediaItem] {
        do {
            
            let strPage = "\(page)"
            let result: MediaResult = try await networkService.performRequest(from: MediaEndpoint.moviesList(page: strPage))
            
            return result.results
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
            return dataSource.getMoviesList()
        }
    }
    
    func fetchMovie(_ id: Int) async throws -> Movie {
        if let movie = dataSource.getMovieDetail(id) {
            return movie
        } else {
            do {
                return try await networkService.performRequest(from: MediaEndpoint.movieDetails(movieID: "\(id)"))
            } catch {
                await errorManager.showError("\(error.localizedDescription)")
                throw error
            }
        }
    }
    //MARK: - Media
    func loadImage(_ path: String) async throws -> Data {
        do {
            let url = try imageService.prepareImagePath(from: path)
            let data = try await imageService.loadImageData(from: url)
            return data
        } catch {
            
            throw error
        }
    }
}
