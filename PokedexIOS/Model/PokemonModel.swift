//
//  PokemonModel.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation

struct PokemonModel {
    let pokemonId: Int
    let pokemonName: String
    let baseExperience: Int
    let height: Int
    let weight: Int
    let types: [String]
    let stats: [Stat]
    let spriteURL: String
    
    struct Stat {
        let baseStat: Int
        let nameStat: String
    }
}
