//
//  K.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation

struct Constants {
    struct PokemonAPI{
        static let URL_POKEMON_LIST = "https://pokeapi.co/api/v2/pokemon-species/" //it uses pagination
        static let URL_POKEMON_DETAIL = "https://pokeapi.co/api/v2/pokemon/" //add the pokemon's name or id
        static let URL_POKEMON_IMAGE = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" //add [pokemon_id].png
        static let URL_POKEMON_MOVE = "https://pokeapi.co/api/v2/move/" //add move's name
    }
    
    struct NibNames {
        static let POKEMON_LIST = "PokemonListVC"
        static let POKEMON_DETAIL = "PokemonDetailVC"
        static let POKEMON_ERROR = "ErrorVC"
        static let POKEMON_MOVES_LIST = "MovesListVC"
        static let POKEMON_MOVE_DETAIL = "MoveDetailVC"
    }
    
    struct Identifiers {
        static let POKEMON_CELL_IDENTIFIER = "cell"
    }
    
    struct Colours {
        static let BLUE_POKEMON_TITLE = "bluePokemonLogo"
        static let BLUE_SHADOW_POKEMON_TITLE = "blueShadowPokemonLogo"
        static let YELLOW_POKEMON_TITLE = "yellowPokemonLogo"
        static let YELLOW_SHADOW_POKEMON_TITLE = "yellowShadowPokemonLogo"
    }
    
    struct Images {
        static let MISSINGNO = "MissingNO"
        static let POKEBALL_FAVOURITE = "pokeballFavourite"
        static let PHYSICAL_MOVE = "physicalMove"
        static let SPECIAL_MOVE = "specialMove"
        static let STATUS_MOVE = "statusMove"
    }
}
