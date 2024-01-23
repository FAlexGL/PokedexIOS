//
//  ApiPokemonDataSource.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation
import Combine

protocol ApiPokemonDataSource {
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListModel?, Never>
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error>
}

class DefaultApiPokemonDataSource {
    private var apiHelper: APIHelper
    private var pokemonHandler: ((Result<PokemonListModel, Error>) -> Void)?
    
    init(apiHelper: APIHelper) {
        self.apiHelper = apiHelper
    }
}

extension DefaultApiPokemonDataSource: ApiPokemonDataSource {
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        apiHelper.fetchPokemonMove(urlString: urlString)
    }
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListModel?, Never> {
        apiHelper.fetchPokemonList(url: url)
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never> {
        apiHelper.fetchPokemonDetail(pokemonId: pokemonId)
    }
    
}
