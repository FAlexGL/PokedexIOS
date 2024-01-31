//
//  FetchPokemonUseCaseMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import Foundation
import Combine
@testable import PokedexIOS

final class FetchPokemonUseCaseMock: FetchPokemonsUseCase {
    
    var pokemonListMock = PokemonListMock()
    var pokemonMock = PokemonMock()
    var moveDTOMock = MoveDTOMock()
    var pokemonIdOrNameSpy: String?
    
    func fetchPokemonList(url: String?) -> AnyPublisher<PokemonListRepresentable, Error> {
        return Just(pokemonListMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail<T>(pokemonIdOrName: T) -> AnyPublisher<PokemonRepresentable, Error> {
        pokemonIdOrNameSpy = String(describing: pokemonIdOrName)
        return Just(pokemonMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTORepresentable, Error> {
        return Just(moveDTOMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
