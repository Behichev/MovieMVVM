//
//  ErrorView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import SwiftUI

struct ErrorView: View {
    
    let errorMessage: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
            Text(errorMessage)
                .foregroundStyle(.white)
        }
        .frame(width: 320)
        .padding(.vertical, 24)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: Constants.Design.LayoutConstants.cornerRadius.rawValue)
                .foregroundStyle(.red.opacity(0.9))
        }
    }
}
