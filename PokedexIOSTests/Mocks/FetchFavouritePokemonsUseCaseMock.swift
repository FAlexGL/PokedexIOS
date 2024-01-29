//
//  FetchFavouritePokemonsUseCaseMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 29/1/24.
//

import Foundation
@testable import PokedexIOS

final class FetchFavouritePokemonsUseCaseMock: FetchFavouritePokemonsUseCase {
    
    private let favouritePokemons: [FavouritePokemon] = []
    
    func fetchFavouritePokemons() -> Result<[FavouritePokemon], Error> {
        return Result.success(favouritePokemons)
    }
    
    
}
