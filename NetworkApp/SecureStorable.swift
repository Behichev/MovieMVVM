//
//  SecureStorable.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 08.05.2025.
//

import Foundation

protocol SecureStorable {
    func save<T: Codable>(_ object: T, forKey key: String)
    func get<T: Codable>(forKey key: String, as type: T.Type) -> T?
    func delete(forKey key: String)
}
