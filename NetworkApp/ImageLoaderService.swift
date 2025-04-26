//
//  ImageLoaderService.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.04.2025.
//

import Foundation

protocol ImageLoaderService {
    func loadImageData(from url: URL) async throws -> Data
}


