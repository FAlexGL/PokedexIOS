//
//  FetchPokemonsUseCase.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation
import Combine

protocol FetchPokemonsUseCase {
    func fetchPokemonList() -> AnyPublisher<PokemonListRepresentable, Error>
    func fetchPokemonList(url: String?) -> AnyPublisher<PokemonListRepresentable, Error>
    func fetchPokemonDetail<T>(pokemonIdOrName: T) -> AnyPublisher<PokemonRepresentable, Error>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error>
}

extension FetchPokemonsUseCase {
    func fetchPokemonList() -> AnyPublisher<PokemonListRepresentable, Error> {
        fetchPokemonList(url: nil)
    }
}

class DefaultFetchPokemonsUseCase {
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
}

extension DefaultFetchPokemonsUseCase: FetchPokemonsUseCase {
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        pokemonRepository.fetchPokemonMove(urlString: urlString)
    }
    
    func fetchPokemonList(url: String?) -> AnyPublisher<PokemonListRepresentable, Error> {
        if let url = url {
            pokemonRepository.fetchPokemonList(url: url)
        } else {
            pokemonRepository.fetchPokemonList(url: Constants.PokemonAPI.URL_POKEMON_LIST)
        }
    }
    
    func fetchPokemonDetail<T>(pokemonIdOrName: T) -> AnyPublisher<PokemonRepresentable, Error> {
        pokemonRepository.fetchPokemonDetail(pokemonIdOrName: String(describing: pokemonIdOrName))
    }
    
}

