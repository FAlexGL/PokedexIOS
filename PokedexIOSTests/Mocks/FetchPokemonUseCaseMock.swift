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
    
    func fetchPokemonList(url: String?) -> AnyPublisher<PokemonListRepresentable, Error> {
        return Just(pokemonListMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonRepresentable, Error> {
        return Just(pokemonMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        return Just(pokemonListMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
