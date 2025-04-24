//
//  DataDecoder.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import Foundation

protocol DataDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

struct JSONDataDecoder: DataDecoder {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
}
