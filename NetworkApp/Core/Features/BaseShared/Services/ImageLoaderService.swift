//
//  ImageLoaderService.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import Foundation

protocol ImageLoaderService {
    func loadImageData(from url: URL) async throws -> Data
    func prepareImagePath(from string: String, size: Int) throws -> URL
}
