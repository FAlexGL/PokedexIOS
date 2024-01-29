//
//  UpdateFavouritePokemonsUseCaseMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 29/1/24.
//

import Foundation
@testable import PokedexIOS

final class UpdateFavouritePokemonsUseCaseMock: UpdateFavouritePokemonsUseCase {
    func updateFavourite(favouritePokemon: PokedexIOS.FavouritePokemon) -> Bool {
        return true
    }
    
}
