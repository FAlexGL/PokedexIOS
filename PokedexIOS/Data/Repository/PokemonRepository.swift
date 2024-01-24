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
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListDTO, Error>
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonDTO, Error>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error>
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool
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
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListDTO, Error> {
        apiDataSource.fetchPokemonList(url: url)
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonDTO, Error> {
        apiDataSource.fetchPokemonDetail(pokemonId: pokemonId)
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        apiDataSource.fetchPokemonMove(urlString: urlString)
    }
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool {
        dbDataSource.updateFavourite(favouritePokemon: favouritePokemon)
    }
}
