//
//  UpdateFavouritePokemonsUseCase.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 23/1/24.
//

import Foundation

protocol UpdateFavouritePokemonsUseCase {
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool
}

class DefaultUpdateFavouritePokemonsUseCase {
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
}

extension DefaultUpdateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase {
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool {
        pokemonRepository.updateFavourite(favouritePokemon: favouritePokemon)
    }
}
