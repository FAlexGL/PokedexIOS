//
//  PokemonMoves.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 24/1/24.
//

import Foundation

struct PokemonMove {
    let moveName: String
    let moveURL: String
    var moves: [String: [(level: Int, game: String)]] //Key value: Learn method
}
