//
//  PokemonDetailPresenterMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import Foundation
import UIKit
@testable import PokedexIOS


final class PokemonDetailPresenterMock: PokemonDetailPresenter {
    var delegate: PokedexIOS.PokemonDetailViewDelegate?
    
    func movesButtonPushed(pokemonMoves: [PokedexIOS.PokemonMove], learnMethod: String) {
        return
    }
    
    func getPokemonDetail(pokemonId: Int) {
        return
    }
    
    func downloadImage(urlString: String) {
        return
    }
    
    func getSprites(pokemonSprites: PokedexIOS.Sprites) {
        return
    }
    
    func getTypesValues(types: [String]) {
        return
    }
    
    func switchChanged(_ sender: UISwitch, pokemonDTO: PokedexIOS.PokemonDTO?) {
        return
    }
    
    func isFavourite(pokemonId: Int) {
        return
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer, sprites: [String], spritePosition: Int) {
        return
    }
    
    
    
    
}
