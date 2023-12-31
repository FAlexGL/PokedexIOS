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
    let stats: [(statName:String, baseStat:Int)]
    let sprites: Sprites
    let moves: [Move]
    
    struct Move{
        let moveName: String
        let moveURL: String
        let learnMethod: String
        let moveVersionDetails: [(level: Int, game: String)]
    }
    
    struct Sprites {
        let frontDefault: String
        let backDefault: String?
        let backFemale: String?
        let backShiny: String?
        let backShinyFemale: String?
        let frontFemale: String?
        let frontShiny: String?
        let frontShinyFemale: String?
        let officialFront: String?
        let officialFrontShiny: String?
    }
}
