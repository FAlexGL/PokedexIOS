//
//  PokemonListModel.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation

struct PokemonListData: Decodable {
    let next: String?
    let previous: String?
    let results: [Result]
}

struct Result: Decodable {
    let name: String
    let url: String
}
