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
    
    override func setUp() {
        pokemonRepositoryMock = PokemonRepositoryMock()
        
    }
    
    // func didSelectRowAt(showFavouritesButtonTitle: String?, indexPath: IndexPath, favouritePokemonsFetched: [FavouritePokemon])
    
    func test_Given_PokemonListPresenter_When_DidSelectedRowAtisCalled_Then_PokemonIdFetchedSuccessfully() {
        // Given
        let sut = DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: pokemonRepositoryMock as! FetchPokemonsUseCase, fetchFavouritesPokemonsUseCase: <#T##FetchFavouritesPokemonsUseCase#>, updateFavouritePokemonsUseCase: <#T##UpdateFavouritePokemonsUseCase#>)
    }
    
}
