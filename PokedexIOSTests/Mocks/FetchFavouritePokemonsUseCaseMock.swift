//
//  FetchFavouritePokemonsUseCaseMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 29/1/24.
//

import Foundation
@testable import PokedexIOS

final class FetchFavouritePokemonsUseCaseMock: FetchFavouritePokemonsUseCase {
    
    private let favouritePokemon1 = FavouritePokemon(pokemonId: 0, pokemonName: "missingno")
    private let favouritePokemon2 = FavouritePokemon(pokemonId: 1, pokemonName: "missingno2")
    private var favouritePokemons: [FavouritePokemon] = []
    
    init() {
        favouritePokemons.append(favouritePokemon1)
        favouritePokemons.append(favouritePokemon2)
    }
    
    func fetchFavouritePokemons() -> Result<[FavouritePokemon], Error> {
        return Result.success(favouritePokemons)
    }
    
    
}
