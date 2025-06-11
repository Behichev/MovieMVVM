//
//  DiscoverCoordinatorView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

struct DiscoverCoordinatorView: View {
    
    @Bindable var coordinator: DiscoverCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView
                .navigationDestination(for: DiscoverCoordinatorPages.self) { page in
                    coordinator.build(page)
                }
        }
    }
}
