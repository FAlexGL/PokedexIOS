//
//  MovesCoordinatorMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import UIKit
@testable import PokedexIOS

final class MovesCoordinatorMock: MovesCoordinator {
    var pokemonMoves: [PokemonMove]?
    var learnMethod: String?
    var childCoordinator: [Coordinator]
    var navigationController: UINavigationController
    var goToMoveDetailHasBeenCalled = false
    var startHasBeenCalled = false
    
    init() {
        
        let pokemonMove = PokemonMove(moveName: "move", moveURL: "www.move.es", moves: [Constants.MoveLearnMethods.LEVEL_METHOD : [(level: 0, game: "Pokemon white")]])
        
        self.pokemonMoves = [pokemonMove]
        self.learnMethod = Constants.MoveLearnMethods.LEVEL_METHOD
        self.childCoordinator = []
        self.navigationController = UINavigationController()
    }
    
    func goToMoveDetail(moveName: String, pokemonMove: PokemonMove, learnMethod: String) {
        goToMoveDetailHasBeenCalled = true
    }
    
    func start() {
        startHasBeenCalled = true
    }
    
}
