//
//  PokemonListTests.swift
//  PokemonListTests
//
//  Created by Geethanjali Gopala Krishnan on 02/05/2024.
//

import XCTest
@testable import PokemonList

final class PokemonListTests: XCTestCase {
    var sut: PokemonListViewModel!

    override func setUpWithError() throws {
       sut = PokemonListViewModel(manager: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchPokemonList_Success() async {
        // Given
        
        // When
        await sut.fetchPokemonList(urlString: "PokemonList")
        
        // Then
        XCTAssertEqual(sut.filteredPokemons.count, 100)
        XCTAssertEqual(sut.filteredPokemons[0].name, "bulbasaur")
    }
    
    func test_fetchPokemonList_Failure() async {
        // Given
        
        // When
        await sut.fetchPokemonList(urlString: "abcd")
        
        // Then
        XCTAssertEqual(sut.filteredPokemons.count, 0)
        XCTAssertNotNil(sut.networkErrors)
    }
}

final class MockNetworkManager: Networkable {
    func fetchFromAPI<T>(urlString: String, type: T.Type) async throws -> T where T : Codable {
        let bundle = Bundle(for: MockNetworkManager.self)
        let fileURL = bundle.url(forResource: urlString, withExtension: "json")
        guard let fileURL = fileURL else { throw NetworkErrors.invalidURL }
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(type.self, from: data)
            return decodedData
        } catch {
            throw error
        }
    }
}
