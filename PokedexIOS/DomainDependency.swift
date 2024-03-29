//
//  DomainDependency.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 15/1/24.
//

import Foundation

protocol DomainDependency {
    func resolve() -> FetchPokemonsUseCase
    func resolve() -> FetchFavouritePokemonsUseCase
}

extension DomainDependency where Self: DefaultAppDependency {
    func resolve() -> FetchPokemonsUseCase {
        DefaultFetchPokemonsUseCase(pokemonRepository: resolve())
    }
    func resolve() -> FetchFavouritePokemonsUseCase {
        DefaultFetchFavouritesPokemonsUseCase(pokemonRepository: resolve())
    }
    
    func resolve() -> UpdateFavouritePokemonsUseCase {
        DefaultUpdateFavouritePokemonsUseCase(pokemonRepository: resolve())
    }
}
