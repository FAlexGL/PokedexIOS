//
//  PokemonListModel.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation

struct PokemonListModel {
    let nextURL: String
    let previousURL: String?
    let pokemons: [String]
    //TODO: haser algo
//    let pokemons: [PokemonItemModel]
    
}

struct PokemonItemModel {
    let pokemonId: Int
    let pokemonName: String
    let isFavourite: Bool
}
