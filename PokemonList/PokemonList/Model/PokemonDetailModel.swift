//
//  PokemonDetailModel.swift
//  PokemonList
//
//  Created by Geethanjali on 03/05/2024.
//

import Foundation

// MARK: - PokemonDetailModel
struct PokemonDetailModel: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    let stats: [Stat]
}

// MARK: - Stat
struct Stat: Codable {
    let baseStat, effort: Int
    let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: - Sprites
struct Sprites: Codable {
    let frontDefault: String
    let frontShiny: String
    let backDefault: String
    let backShiny: String
  
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
    }
}

extension Stat: Identifiable {
    var id: UUID {
        return UUID()
    }
}

extension Sprites: Identifiable {
    var id: UUID {
        return UUID()
    }
}
