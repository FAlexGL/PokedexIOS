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
    
    func fetchFavouritesPokemons() -> [FavouritePokemon] {
        []
    }
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListRepresentable, Error> {
        fetchPokemonListWithDefaultUrl = url == Constants.PokemonAPI.URL_POKEMON_LIST
        fetchPokemonListWithParameterUrl = url != Constants.PokemonAPI.URL_POKEMON_LIST
        return Just(pokemonListMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonDTO, Error> {
        Fail(error: NSError()).eraseToAnyPublisher()
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        Fail(error: NSError()).eraseToAnyPublisher()
    }
    
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool {
        true
    }
}
