//
//  RootView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

struct RootView: View {
    private let authStore: AuthenticationStore
    private let repository: TMDBRepositoryProtocol
    @StateObject private var rootCoordinator: RootCoordinator
    
    init(authStore: AuthenticationStore, repository: TMDBRepositoryProtocol) {
        self.authStore = authStore
        self.repository = repository
        self._rootCoordinator = StateObject(wrappedValue: RootCoordinator(authStore: authStore, repository: repository))
    }
    
    var body: some View {
        rootCoordinator.rootView
    }
}
