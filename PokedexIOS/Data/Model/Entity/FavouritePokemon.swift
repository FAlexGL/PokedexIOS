//
//  PokemonFavourite.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation
import RealmSwift

// TODO: Rename to Entity
class FavouritePokemon: Object {
    @Persisted(primaryKey: true) var pokemonId: Int
    @Persisted var pokemonName: String
    
    convenience init(pokemonId: Int, pokemonName: String) {
        self.init()
        self.pokemonId = pokemonId
        self.pokemonName = pokemonName
    }
}
