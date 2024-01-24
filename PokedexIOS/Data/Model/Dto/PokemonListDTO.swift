//
//  PokemonListModel.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation

struct PokemonListDTO: Decodable, PokemonListRepresentable {
    let next: String?
    let previous: String?
    let results: [PokemonListResult]
}

struct PokemonListResult: Decodable {
    let name: String
    let url: String
}
