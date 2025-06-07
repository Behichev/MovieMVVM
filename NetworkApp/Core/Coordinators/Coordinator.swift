//
//  Coordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

protocol Coordinator: ObservableObject {
    associatedtype Content: View
    @MainActor @ViewBuilder var rootView: Content { get }
    func closeAllChild()
}
