//
//  PokemonSpecieRepresentable.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 27/2/24.
//

import Foundation

protocol PokemonSpecieRepresentable {
    var evolutionChainRepresentable: EvolutionChainRepresentable { get }
    var evolvesFromSpeciesRepresentable: EvolvesFromSpeciesRepresentable? { get }
}

protocol EvolutionChainRepresentable {
    var url: String { get }
}

protocol EvolvesFromSpeciesRepresentable {
    var name: String { get }
    var url: String { get }
}
