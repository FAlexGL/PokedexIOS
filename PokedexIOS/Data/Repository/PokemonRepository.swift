//
//  PokemonRepository.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation
import Combine

protocol PokemonRepository {
    func fetchFavouritesPokemons() -> [FavouritePokemon]
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListModel?, Never>
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveModel?, Never>
}

class DefaultPokemonRepository {
    private let apiDataSource: ApiPokemonDataSource
    private let dbDataSource: DBPokemonDataSource
    
    init(apiDataSource: ApiPokemonDataSource, dbDataSource: DBPokemonDataSource) {
        self.apiDataSource = apiDataSource
        self.dbDataSource = dbDataSource
    }
}

extension DefaultPokemonRepository: PokemonRepository {
    
    func fetchFavouritesPokemons() -> [FavouritePokemon] {
        dbDataSource.fetchFavouritesPokemons()
    }
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListModel?, Never> {
        apiDataSource.fetchPokemonList(url: url)
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never> {
        apiDataSource.fetchPokemonDetail(pokemonId: pokemonId)
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveModel?, Never> {
        apiDataSource.fetchPokemonMove(urlString: urlString)
    }
}
