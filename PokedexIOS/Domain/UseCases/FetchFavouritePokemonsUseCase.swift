//
//  FetchFavouritesPokemonsUseCase.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol FetchFavouritePokemonsUseCase {
    func fetchFavouritePokemons() -> Result<[FavouritePokemon], Error>
}

class DefaultFetchFavouritesPokemonsUseCase {
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
}

extension DefaultFetchFavouritesPokemonsUseCase: FetchFavouritePokemonsUseCase {
    func fetchFavouritePokemons() -> Result<[FavouritePokemon], Error> {
        //TODO: update to Result
        return Result.success(pokemonRepository.fetchFavouritesPokemons())
    }
}
