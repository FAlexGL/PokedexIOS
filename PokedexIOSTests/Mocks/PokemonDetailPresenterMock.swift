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
    
    func getSprites(pokemonSprites: SpritesRepresentable) {
        return
    }
    
    func switchChanged(_ sender: UISwitch, pokemonDTO: PokemonRepresentable?) {
        return
    }
    
    func movesButtonPushed(pokemonMoves: [PokemonMove], learnMethod: String) {
        return
    }
    
    func getPokemonDetail(pokemonId: Int) {
        return
    }
    
    func downloadImage(urlString: String) {
        return
    }
    
    func getTypesValues(types: [String]) {
        return
    }
    
    func isFavourite(pokemonId: Int) {
        return
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer, sprites: [String], spritePosition: Int) {
        return
    }
    
    
    
    
}
