//
//  ApiPokemonDataSource.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation
import Combine

protocol ApiPokemonDataSource {
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListRepresentable, Error>
    func fetchPokemonDetail(pokemonIdOrName: String) -> AnyPublisher<PokemonRepresentable, Error>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error>
}

class DefaultApiPokemonDataSource {
    private var apiHelper: APIHelper
    
    init(apiHelper: APIHelper) {
        self.apiHelper = apiHelper
    }
}

extension DefaultApiPokemonDataSource: ApiPokemonDataSource {
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        apiHelper.fetchPokemonMove(urlString: urlString)
    }
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListRepresentable, Error> {
        apiHelper.fetchPokemonList(url: url)
            .map { $0 as PokemonListRepresentable }
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(pokemonIdOrName: String) -> AnyPublisher<PokemonRepresentable, Error> {
        apiHelper.fetchPokemonDetail(pokemonIdOrName: pokemonIdOrName)
            .map { $0 as PokemonRepresentable }
            .eraseToAnyPublisher()
    }
}
