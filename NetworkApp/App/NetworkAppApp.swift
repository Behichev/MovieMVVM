//
//  NetworkAppApp.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import SwiftUI

@main
struct NetworkAppApp: App {

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
                    RootView(authenticationStore: authenticationStore, repository: repository)
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

struct RootView: View {
    
    @ObservedObject private var authenticationStore: AuthenticationStore
    private var repository: TMDBRepositoryProtocol
    
    init(authenticationStore: AuthenticationStore, repository: TMDBRepositoryProtocol) {
        self.authenticationStore = authenticationStore
        self.repository = repository
    }
    
    enum AppState {
        case login
        case authenticated
    }
    
    private var appState: AppState {
        if authenticationStore.isAuthenticated {
            return .authenticated
        } else {
            return .login
        }
    }
    
    var body: some View {
        switch appState {
        case .login:
            LoginView(repository: repository)
                .environmentObject(authenticationStore)
        case .authenticated:
            TabBarView(repository: repository)
            .environmentObject(authenticationStore)
        }
    }
}
