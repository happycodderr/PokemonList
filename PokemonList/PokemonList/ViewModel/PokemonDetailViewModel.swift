//
//  PokemonDetailViewModel.swift
//  PokemonList
//
//  Created by Geethanjali Gopala Krishnan on 02/05/2024.
//

import Foundation

final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: PokemonDetailModel? = nil
    @Published var viewState: ViewStates = .loading
    @Published var networkErrors: NetworkErrors?
    @Published var imageArray: [String] = []
    private var manager: Networkable
      
    init(manager: Networkable = NetworkManager()) {
        self.manager = manager
    }
    
    @MainActor
    func fetchPokemonDetail(urlString: String) async {
        do {
            viewState = .loading
            pokemon = try await manager.fetchFromAPI(urlString: urlString,
                                                     type: PokemonDetailModel.self)
            guard let pokemon = pokemon else { throw NetworkErrors.invalidData }
        
            imageArray.append(pokemon.sprites.frontDefault)
            imageArray.append(pokemon.sprites.frontShiny)
            imageArray.append(pokemon.sprites.backDefault)
            imageArray.append(pokemon.sprites.backShiny)
            
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
}
