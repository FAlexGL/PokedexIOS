//
//  UpdateFavouritePokemonsUseCaseTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import XCTest
@testable import PokedexIOS

final class UpdateFavouritePokemonsUseCaseTests: XCTestCase {
    var repository: PokemonRepositoryMock!
    var favouritePokemon: FavouritePokemon!

    override func setUp() {
        repository = PokemonRepositoryMock()
        favouritePokemon = FavouritePokemon(pokemonId: 0, pokemonName: "missingno")
    }
    
    func test_Given_UpdateFavouritePokemonsUseCase_When_UpdateFavouriteIsCalled_Then_PkemonDetailReturned() throws {
        // Given "missingno"
        let sut = DefaultUpdateFavouritePokemonsUseCase(pokemonRepository: repository)
        
        // When
        let updated = sut.updateFavourite(favouritePokemon: favouritePokemon)
        
        // Then
        XCTAssertEqual(updated, true)
    }
}
