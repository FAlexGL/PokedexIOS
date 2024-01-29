//
//  PokemonListMock.swift
//  PokedexIOSTests
//
//  Created by Alberto Guerrero Martin on 24/1/24.
//

@testable import PokedexIOS

struct PokemonListMock: PokemonListRepresentable {
    var next: String? = nil
    var previous: String? = nil
    var results: [PokemonListResult] = []
}
