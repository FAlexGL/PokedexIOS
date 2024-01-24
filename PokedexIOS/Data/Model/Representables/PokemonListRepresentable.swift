//
//  PokemonListRepresentable.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 24/1/24.
//

import Foundation

protocol PokemonListRepresentable {
    var next: String? { get }
    var previous: String? { get }
    var results: [PokemonListResult] { get }
}
