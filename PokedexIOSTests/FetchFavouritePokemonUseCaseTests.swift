//
//  FetchFavouritePokemonUseCaseTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import XCTest
@testable import PokedexIOS

final class FetchFavouritePokemonUseCaseTests: XCTestCase {
    var repository: PokemonRepositoryMock!

    override func setUp() {
        repository = PokemonRepositoryMock()
    }
    
    func test_Given_FetchFavouritePokemonUseCase_When_FetchFavouritePokemons_Then_ArrayOfFavouritePokemonsReturnedSuccessfully() {
        // Given
        let sut = DefaultFetchFavouritesPokemonsUseCase(pokemonRepository: repository)
        
        // When
        let favouritePokemons = sut.fetchFavouritePokemons()
        
        // Then
        XCTAssertEqual(try favouritePokemons.get().count, 2)
    }
}
