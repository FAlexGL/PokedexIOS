//
//  PokemonListMock.swift
//  PokedexIOSTests
//
//  Created by Alberto Guerrero Martin on 24/1/24.
//

@testable import PokedexIOS

struct PokemonListMock: PokemonListRepresentable {
    var next: String? = "www.nextURL.com"
    var previous: String? = "www.previousURL.com"
    var results: [PokemonListResult] = []
}
