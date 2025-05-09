//
//  LoaderView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.Design.LayoutConstants.cornerRadius.rawValue)
                .foregroundStyle(.black.opacity(0.7))
                .frame(width: 100, height: 100)
            
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.yellow)
        }
    }
}
