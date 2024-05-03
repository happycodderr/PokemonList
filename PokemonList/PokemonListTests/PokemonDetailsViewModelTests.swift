//
//  PokemonDetailsViewModelTests.swift
//  PokemonListTests
//
//  Created by Geethanjali Gopala Krishnan on 03/05/2024.
//

import XCTest
@testable import PokemonList

final class PokemonDetailsViewModelTests: XCTestCase {
    var sut: PokemonDetailViewModel!

    override func setUpWithError() throws {
       sut = PokemonDetailViewModel(manager: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchPokemonList_Success() async {
        // Given
        
        // When
        await sut.fetchPokemonDetail(urlString: "PokemonDetail")
        
        // Then
        XCTAssertEqual(sut.pokemon?.name, "bulbasaur")
        XCTAssertEqual(sut.pokemon?.stats[0].stat.name, "hp")
        XCTAssertEqual(sut.pokemon?.stats[0].stat.url, "https://pokeapi.co/api/v2/stat/1/")
    }
    
    func test_fetchPokemonList_Failure() async {
        // Given
        
        // When
        await sut.fetchPokemonDetail(urlString: "abcd")
        
        // Then
        XCTAssertNotNil(sut.networkErrors)
    }
}
