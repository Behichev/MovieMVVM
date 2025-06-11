//
//  RootCoordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

@Observable
final class RootCoordinator {
    
    private let authStore: AuthenticationStore
    private let repository: TMDBRepositoryProtocol
    
    private var tabBarCoordinator: TabBarCoordinator?
    
    init(authStore: AuthenticationStore, repository: TMDBRepositoryProtocol) {
        self.authStore = authStore
        self.repository = repository
        
        setupCoordinators()
    }
    
    private func setupCoordinators() {
        tabBarCoordinator = TabBarCoordinator(repository: repository)
    }
    
    @ViewBuilder @MainActor
    var rootView: some View {
        if authStore.isAuthenticated {
            if let tabBarCoordinator = tabBarCoordinator {
                tabBarCoordinator.rootView
                    .environment(authStore)
            }
        } else {
            LoginView(repository: repository)
                .environment(authStore)
        }
    }
}
