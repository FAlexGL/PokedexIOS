//
//  K.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation

struct K {
    struct PokemonAPI{
        static let URL_POKEMON_LIST = "https://pokeapi.co/api/v2/pokemon-species/" //it uses pagination
        static let URL_POKEMON_DETAIL = "https://pokeapi.co/api/v2/pokemon/" //add the pokemon's name or id
        static let URL_POKEMON_IMAGE = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" //add [pokemon_id].png
    }
    
    struct NibNames{
        static let POKEMON_LIST = "PokemonListVC"
        static let POKEMON_DETAIL = "PokemonDetailVC"
    }
    
    struct Identifiers{
        static let POKEMON_CELL_IDENTIFIER = "cell"
    }
}
