//
//  PokemonListViewModel.swift
//  PokemonList
//
//  Created by Geethanjali Gopala Krishnan on 02/05/2024.
//

import Foundation

enum ViewStates {
    case loading
    case loaded
    case error
}

final class PokemonListViewModel: ObservableObject {
    @Published var filteredPokemons: [Pokemon] = []
    @Published var networkErrors: NetworkErrors?
    @Published var viewState: ViewStates = .loading
    private var pokemons: [Pokemon] = []
    private var manager: Networkable
    
    init(manager: Networkable = NetworkManager()) {
        self.manager = manager
    }
    
    @MainActor
    func fetchPokemonList(urlString: String) async {
        do {
            viewState = .loading
            let pokemonData = try await manager.fetchFromAPI(urlString: urlString, 
                                                             type: PokemonModel.self)
            pokemons = pokemonData.results
            filteredPokemons = pokemons
            viewState = .loaded
        } catch {
            print(error)
            switch networkErrors {
            case .invalidURL:
                networkErrors = .invalidURL
            case .invalidData:
                networkErrors = .invalidData
            case nil:
                networkErrors = .invalidData
            }
            viewState = .error
        }
    }
    
    func getImagePath(urlString: String) -> String {
        var number = "1"
        if let lastPathComponent = URL(string: urlString)?.lastPathComponent {
            number = lastPathComponent
        } else {
            print("Invalid URL")
        }
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png"
    }
    func filterPokemon(_ searchText: String) {
        if searchText.isEmpty {
            self.filteredPokemons = self.pokemons
        } else {
            let list = self.pokemons.filter { pokemon in
                return pokemon.name.localizedCaseInsensitiveContains(searchText)
            }
            self.filteredPokemons = list
        }
    }
}
