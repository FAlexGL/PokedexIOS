//
//  DBHelperMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
@testable import PokedexIOS

final class DBHelperMock: DBHelper {
    func isFavourite(pokemonId: Int) -> Bool {
        true
    }
    
    func fetchFavourites() -> [FavouritePokemon] {
        [FavouritePokemon(pokemonId: 0, pokemonName: "missingno"), FavouritePokemon(pokemonId: 1, pokemonName: "missingno2")]
    }
    
    func fetchFavouriteById(pokemonId: Int) -> FavouritePokemon? {
        FavouritePokemon(pokemonId: 0, pokemonName: "missingno")
    }
    
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool {
        true
    }
}
