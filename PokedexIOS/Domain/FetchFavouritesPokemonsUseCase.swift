//
//  FetchFavouritesPokemonsUseCase.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol FetchFavouritesPokemonsUseCase {
    func fetFavouritesPokemons() -> Result<[FavouritePokemon], Error>
}

class DefaultFetchFavouritesPokemonsUseCase {
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
}

extension DefaultFetchFavouritesPokemonsUseCase: FetchFavouritesPokemonsUseCase {
    func fetFavouritesPokemons() -> Result<[FavouritePokemon], Error> {
        //TODO: update to Result
//        .success(pokemonRepository.fetFavouritesPokemons())
        return Result.success(pokemonRepository.fetFavouritesPokemons())
    }
}
