//
//  NetworkAppApp.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

@main
struct NetworkAppApp: App {
    //MARK: Observed
    @ObservedObject private var authenticationStore: AuthenticationStore
    @ObservedObject private var errorManager: ErrorManager
    //MARK: Services
    private var networkService: NetworkServiceProtocol = NetworkService()
    private var imageService: ImageLoaderService = TMDBImageLoader()
    private var keychainService = KeychainService()
    private var moviesStorage = MoviesStorage()
    //MARK: Repositories
    private var repository: TMDBRepositoryProtocol
    //MARK: Init
    init() {
        let errorManager = ErrorManager()
        _errorManager = ObservedObject(wrappedValue: errorManager)
        repository = TMDBRepository(networkService: networkService,
                                    imageService: imageService,
                                    keychainService: keychainService,
                                    dataSource: moviesStorage, errorManager: errorManager)
        let authenticationStore = AuthenticationStore(repository: repository,
                                                      keychainService: keychainService)
        _authenticationStore = ObservedObject(wrappedValue: authenticationStore)
    }
    //MARK: Scene
    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    RootView(authStore: authenticationStore, repository: repository)
                }
                if errorManager.showError {
                    errorView
                }
            }
            .environmentObject(errorManager)
        }
    }
    
    private var errorView: some View {
        GeometryReader { geometry in
            VStack {
                ErrorView(errorMessage: errorManager.currentError ?? "", hide: {
                    errorManager.hideError()
                })
                Spacer()
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
        }
    }
}

