//
//  TrendingCoordinatorView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

struct TrendingCoordinatorView: View {
    
    @ObservedObject var coordinator: TrendingCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView
                .navigationDestination(for: TrendingCoordinatorPages.self) { page in
                    coordinator.build(page)
                }
        }
    }
}
