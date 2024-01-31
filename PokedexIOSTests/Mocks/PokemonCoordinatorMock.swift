//
//  PokemonCoordinatorMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import Foundation
import UIKit
import XCTest
@testable import PokedexIOS


final class PokemonCoordinatorMock: PokemonCoordinator {
    
    var pokemonId: Int?
    var goToPokemonDetailExpectation: XCTestExpectation?
    var goToPokemonDetailHasBeenCalled = false
    var goToPokemonMovesHasBeenCalled = false
    
    func goToPokemonDetail(pokemonId: Int, delegate: PokemonDetailDelegate) {
        goToPokemonDetailExpectation?.fulfill()
        self.goToPokemonDetailHasBeenCalled = true
        self.pokemonId = pokemonId
    }
    
    func goToPokemonMoves(pokemonMoves: [PokemonMove], learnMethod: String) {
        goToPokemonMovesHasBeenCalled = true
    }
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()
    
    func start() {
        print("start")
    }
}
