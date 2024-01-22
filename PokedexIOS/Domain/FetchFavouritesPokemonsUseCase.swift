//
//  FetchFavouritesPokemonsUseCase.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol FetchFavouritesPokemonsUseCase {
    func fetchFavouritesPokemons() -> Result<[FavouritePokemon], Error>
}

class DefaultFetchFavouritesPokemonsUseCase {
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
}

extension DefaultFetchFavouritesPokemonsUseCase: FetchFavouritesPokemonsUseCase {
    func fetchFavouritesPokemons() -> Result<[FavouritePokemon], Error> {
        //TODO: update to Result
        return Result.success(pokemonRepository.fetchFavouritesPokemons())
    }
}
