//
//  PokemonListViewDelegateMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 30/1/24.
//

import Foundation
@testable import PokedexIOS

final class PokemonListViewDelegateMock: PokemonListViewDelegate {
    
    var didUpdatePokemonListHasBeenCalled = false
    var favouriteUpdatedHasBeenCalled = false
    var favouriteLoadedHasBeenCalled = false
    var favouriteChangedHasBeenCalled = false
    var didFailWithErrorHasBeenCalled = false
    var pokemonListDTO: PokemonListRepresentable?
    
    func didUpdatePokemonList(pokemonListDTO: PokemonListRepresentable) {
        didUpdatePokemonListHasBeenCalled = true
        self.pokemonListDTO = pokemonListDTO
    }
    
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        favouriteUpdatedHasBeenCalled = true
    }
    
    func favouriteLoaded(pokemons: [FavouritePokemon]) {
        favouriteLoadedHasBeenCalled = true
    }
    
    func favouriteChanged(result: Bool, messageError: String, indexPath: IndexPath) {
        favouriteChangedHasBeenCalled = true
    }
    
    func didFailWithError(error: Error) {
        didFailWithErrorHasBeenCalled = true
    }
}
