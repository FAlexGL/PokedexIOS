//
//  MoveDetailViewDelegateMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
@testable import PokedexIOS

final class MoveDetailViewDelegateMock: MoveDetailViewDelegate {
    
    var didUpdatePokemonMoveHasBeenCalled = false
    var didUpdatePokemonMoveDataHasBeenCalled = false
    
    func didUpdatePokemonMove(moveDTORepresentable: MoveDTORepresentable) {
        didUpdatePokemonMoveHasBeenCalled = true
    }
    
    func didUpdateMoveData(moveData: [String : String], levelGames: NSMutableAttributedString) {
        didUpdatePokemonMoveDataHasBeenCalled = true
    }
    
    
}
