//
//  PokemonDetailViewDelegateMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import UIKit
@testable import PokedexIOS

final class PokemonDetailViewDelegateMock: PokemonDetailViewDelegate {
    
    var didUpdatePokemonDetailHasBeenCalled = false
    var didFailWithErrorHasBeenCalled = false
    var showImageHasBeenCalled = false
    var didUpdateSpritesHasBeenCalled = false
    var typesValuesFetchedHasBeenCalled = false
    var setFavouriteHasBeenCalled = false
    var setSwitchStatusHasBeenCalled = false
    var setSpritePositionHasBeenCalled = false
    
    func didUpdatePokemonDetail(pokemonDTO: PokemonRepresentable) {
        didUpdatePokemonDetailHasBeenCalled = true
    }
    
    func didFailWithError(error: Error) {
        didFailWithErrorHasBeenCalled = true
    }
    
    func showImage(image: UIImage) {
        showImageHasBeenCalled = true
    }
    
    func didUpdateSprites(spritesArray: [String]) {
        didUpdateSpritesHasBeenCalled = true
    }
    
    func typesValuesFetched(types: [String : Double]) {
        typesValuesFetchedHasBeenCalled = true
    }
    
    func setFavourite(isFavourite: Bool) {
        setFavouriteHasBeenCalled = true
    }
    
    func setSwitchStatus(switchStatus: Bool) {
        setSwitchStatusHasBeenCalled = true
    }
    
    func setSpritePosition(spritePosition: Int) {
        setSpritePositionHasBeenCalled = true
    }
    
    
}
