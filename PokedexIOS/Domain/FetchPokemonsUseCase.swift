//
//  FetchPokemonsUseCase.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol FetchPokemonsUseCase {
    func fetchPokemons(handler: @escaping (Result<PokemonListModel, Error>) -> Void)
    func fetchPokemons(url: String?, handler: @escaping (Result<PokemonListModel, Error>) -> Void)
}

extension FetchPokemonsUseCase {
    func fetchPokemons(handler: @escaping (Result<PokemonListModel, Error>) -> Void) {
        fetchPokemons(url: nil, handler: handler)
    }
}

class DefaultFetchPokemonsUseCase {
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
}

extension DefaultFetchPokemonsUseCase: FetchPokemonsUseCase {
    
    func fetchPokemons(url: String?,handler: @escaping (Result<PokemonListModel, Error>) -> Void) {
        if let url = url {
            pokemonRepository.fetchMorePokemons(url: url, handler: handler)
        } else {
            pokemonRepository.fetchPokemons(handler: handler)
        }
    }
    
}
