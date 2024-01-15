//
//  ApiPokemonDataSource.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol ApiPokemonDataSource {
    func fetchPokemons(handler: @escaping (Result<PokemonListModel, Error>) -> Void)
    func fetchMorePokemons( url: String, handler: @escaping (Result<PokemonListModel, Error>) -> Void)
}

class DefaultApiPokemonDataSource {
    private var apiHelper: APIHelper
    private var pokemonHanlder: ((Result<PokemonListModel, Error>) -> Void)?
    
    init(apiHelper: APIHelper) {
        self.apiHelper = apiHelper
        self.apiHelper.delegate = self
    }
    
}

extension DefaultApiPokemonDataSource: ApiPokemonDataSource {
    func fetchPokemons(handler: @escaping (Result<PokemonListModel, Error>) -> Void) {
        self.pokemonHanlder = handler
        apiHelper.fetchPokemonList(url: Constants.PokemonAPI.URL_POKEMON_LIST)
    }
    
    func fetchMorePokemons( url: String, handler: @escaping (Result<PokemonListModel, Error>) -> Void) {
        self.pokemonHanlder = handler
        apiHelper.fetchPokemonList(url: url)
    }
    
}

extension DefaultApiPokemonDataSource: APIHelperDelegate {
    func didFailWithError(error: Error) {
        pokemonHanlder?(.failure(error))
    }
    
    func didUpdatePokemonList(pokemonListModel: PokemonListModel) {
        pokemonHanlder?(.success(pokemonListModel))
    }
}
