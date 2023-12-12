//
//  PokemonData.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation

struct PokemonData: Decodable{
    let id: Int
    let name: String
    let base_experience: Int
    let height: Int
    let weight: Int
    let types: [Types]
    let stats: [Stats]
    let sprites: Sprites
}

struct Types: Decodable{
    let slot: Int
    let type: Type
}

struct Type: Decodable{
    let name: String
    let url: String
}

struct Stats: Decodable {
    let base_stat: Int
    let stat: Stat
}

struct Stat: Decodable{
    let name: String
    let url: String
}

struct Sprites: Decodable{
    let front_default: String
}
