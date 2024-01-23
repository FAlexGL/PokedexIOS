//
//  FetchPokemonsUseCase.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation
import Combine

protocol FetchPokemonsUseCase {
    func fetchPokemonList() -> AnyPublisher<PokemonListModel?, Never>
    func fetchPokemonList(url: String?) -> AnyPublisher<PokemonListModel?, Never>
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error>
}

extension FetchPokemonsUseCase {
    func fetchPokemonList() -> AnyPublisher<PokemonListModel?, Never> {
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
    
    func fetchPokemonList(url: String?) -> AnyPublisher<PokemonListModel?, Never> {
        if let url = url {
            pokemonRepository.fetchPokemonList(url: url)
        } else {
            pokemonRepository.fetchPokemonList(url: Constants.PokemonAPI.URL_POKEMON_LIST)
        }
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never> {
        pokemonRepository.fetchPokemonDetail(pokemonId: pokemonId)
    }
    
}

