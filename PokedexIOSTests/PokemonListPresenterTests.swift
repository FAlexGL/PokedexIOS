//
//  PokemonListPresenterTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import XCTest
@testable import PokedexIOS

final class PokemonListPresenterTests: XCTestCase {
    
    var coordinator: PokemonCoordinator = PokemonCoordinatorMock()
    var pokemonRepositoryMock: PokemonRepositoryMock!
    var fetchFavouritePokemonsUseCase: FetchFavouritePokemonsUseCaseMock!
    var updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCaseMock!
    
    override func setUp() {
        pokemonRepositoryMock = PokemonRepositoryMock()
        fetchFavouritePokemonsUseCase = FetchFavouritePokemonsUseCaseMock()
        updateFavouritePokemonsUseCase = UpdateFavouritePokemonsUseCaseMock()
    }
    
    // func didSelectRowAt(showFavouritesButtonTitle: String?, indexPath: IndexPath, favouritePokemonsFetched: [FavouritePokemon])
    
    func test_Given_PokemonListPresenter_When_DidSelectedRowAtisCalled_Then_PokemonIdFetchedSuccessfully() {
        // Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: pokemonRepositoryMock as! FetchPokemonsUseCase, fetchFavouritePokemonsUseCase: fetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: updateFavouritePokemonsUseCase)
    }
    
}
