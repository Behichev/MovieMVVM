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
    @Bindable private var authenticationStore: AuthenticationStore
    @Bindable private var errorManager: ErrorManager
    //MARK: Services
    private var networkService: NetworkServiceProtocol = NetworkService()
    private var imageService: ImageLoaderService = TMDBImageLoader()
    private var keychainService = KeychainService()
    @Bindable private var moviesStorage = MoviesStorage()
    //MARK: Repositories
    private var repository: TMDBRepositoryProtocol
    //MARK: Init
    init() {
        let errorManager = ErrorManager()
        _errorManager = Bindable(wrappedValue: errorManager)
        repository = TMDBRepository(
            networkService: networkService,
            imageService: imageService,
            keychainService: keychainService,
            errorManager: errorManager
        )
        let authenticationStore = AuthenticationStore(repository: repository,
                                                      keychainService: keychainService)
        _authenticationStore = Bindable(wrappedValue: authenticationStore)
    }
    //MARK: Scene
    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    RootView(authStore: authenticationStore, repository: repository, mediaStorage: moviesStorage)
                }
                if errorManager.showError {
                    errorView
                }
            }
            .environment(errorManager)
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
