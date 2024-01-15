//
//  DBPokemonDataSource.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol DBPokemonDataSource {
    func fetchFavouritesPokemons() -> [(Int, String)]
}

class DefaultDBPokemonDataSource {
    
    private let dbHelper: DBHelper
    
    init(dbHelper: DBHelper) {
        self.dbHelper = dbHelper
    }
}

extension DefaultDBPokemonDataSource: DBPokemonDataSource {
    
    func fetchFavouritesPokemons() -> [(Int, String)] {
        dbHelper.fetchFavourites()
    }

}
