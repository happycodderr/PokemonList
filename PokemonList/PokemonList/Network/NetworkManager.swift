//
//  NetworkManager.swift
//  PokemonList
//
//  Created by Geethanjali Gopala Krishnan on 02/05/2024.
//

import Foundation

protocol Networkable {
    func fetchFromAPI<T>(urlString: String, type: T.Type) async throws -> T where T: Codable
}

final class NetworkManager: Networkable {
    func fetchFromAPI<T>(urlString: String, type: T.Type) async throws -> T where T: Codable {
        guard let url = URL(string: urlString) else { throw NetworkErrors.invalidURL }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // Using URLSession, we get data, response and error
            let decodedData = try JSONDecoder().decode(type.self, from: data) // We decode the data using the JSONDecoder
            return decodedData
        } catch {
            throw error
        }
    }
}
