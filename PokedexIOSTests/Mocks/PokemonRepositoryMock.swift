//
//  PokemonRepositoryMock.swift
//  PokedexIOSTests
//
//  Created by Alberto Guerrero Martin on 24/1/24.
//

import Foundation
import Combine
@testable import PokedexIOS

final class PokemonRepositoryMock: PokemonRepository {    
    
    var fetchPokemonListWithDefaultUrl = false
    var fetchPokemonListWithParameterUrl = false
    
    var pokemonListMock = PokemonListMock()
    var moveDTOMock = MoveDTOMock()
    var pokemonMock = PokemonMock()
    var favouritePokemon1 = FavouritePokemon(pokemonId: 0, pokemonName: "missingno")
    var favouritePokemon2 = FavouritePokemon(pokemonId: 1, pokemonName: "missingno2")
    
    func fetchFavouritesPokemons() -> [FavouritePokemon] {
        [favouritePokemon1, favouritePokemon2]
    }
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListRepresentable, Error> {
        fetchPokemonListWithDefaultUrl = url == Constants.PokemonAPI.URL_POKEMON_LIST
        fetchPokemonListWithParameterUrl = url != Constants.PokemonAPI.URL_POKEMON_LIST
        return Just(pokemonListMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(pokemonIdOrName: String) -> AnyPublisher<PokemonRepresentable, Error> {
        return Just(pokemonMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTORepresentable, Error> {
        return Just(moveDTOMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool {
        true
    }
}
