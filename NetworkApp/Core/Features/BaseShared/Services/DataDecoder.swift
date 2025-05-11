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
