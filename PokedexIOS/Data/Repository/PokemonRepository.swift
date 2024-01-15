//
//  PokemonRepository.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol PokemonRepository {
    func fetchPokemons(handler: @escaping (Result<PokemonListModel, Error>) -> Void)
    func fetchMorePokemons(url: String, handler: @escaping (Result<PokemonListModel, Error>) -> Void)
    func fetFavouritesPokemons() -> [(Int, String)]
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
    
    func fetchPokemons(handler: @escaping (Result<PokemonListModel, Error>) -> Void) {
        apiDataSource.fetchPokemons(handler: handler)
    }
    
    func fetchMorePokemons(url: String, handler: @escaping (Result<PokemonListModel, Error>) -> Void) {
        apiDataSource.fetchMorePokemons(url: url, handler: handler)
    }
    
    func fetFavouritesPokemons() -> [(Int, String)] {
        dbDataSource.fetchFavouritesPokemons()
    }
}
