//
//  FetchPokemonsUseCaseTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import XCTest
@testable import PokedexIOS

final class FetchPokemonsUseCaseTests: XCTestCase {
    
    var repository: PokemonRepositoryMock!

    override func setUp() {
        repository = PokemonRepositoryMock()
    }
        
    func test_Given_FetchPokemonsUseCase_When_FetchPokemonListIsCalled_Then_FirstPageOfPokemonListIsReturnedSuccessfully() throws {
        // Given
        repository.pokemonListMock.results = [
            PokemonListResult(name: "Charmander", url: "")
        ]
        
        let sut = DefaultFetchPokemonsUseCase(pokemonRepository: repository)
        
        // When
        let pokemonList = try sut.fetchPokemonList().sinkAwait()
        
        // Then
        XCTAssertEqual(pokemonList.results.first?.name, "Charmander")
    }
    
    func test_Given_FetchPokemonsUseCase_When_FetchPokemonListWithUrlIsCalled_Then_RepositoryIsCalledWithUrlPassedAsParameter() throws {
        // Given
        let sut = DefaultFetchPokemonsUseCase(pokemonRepository: repository)
        
        // When
        _ = try sut.fetchPokemonList(url: "https://google.es").sinkAwait()
        
        // Then
        XCTAssertTrue(repository.fetchPokemonListWithParameterUrl)
    }

    func test_Given_FetchPokemonsUseCase_When_FetchPokemonListWithoutUrlIsCalled_Then_RepositoryIsCalledWithDefaultUrl() throws {
        // Given
        let sut = DefaultFetchPokemonsUseCase(pokemonRepository: repository)
        
        // When
        _ = try sut.fetchPokemonList(url: nil).sinkAwait()
        
        // Then
        XCTAssertTrue(repository.fetchPokemonListWithDefaultUrl)
    }

}
