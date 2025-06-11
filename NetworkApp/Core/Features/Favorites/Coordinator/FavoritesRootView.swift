//
//  FavoritesCoordinatorView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

struct FavoritesRootView: View {
    
    @Bindable var coordinator: FavoritesCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView
                .navigationDestination(for: FavoritesCoordinatorPages.self) { page in
                    coordinator.build(page)
                }
        }
    }
}
