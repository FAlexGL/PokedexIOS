//
//  PokemonCoordinatorMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import Foundation
import UIKit
@testable import PokedexIOS


final class PokemonCoordinatorMock: PokemonCoordinator {
    
    func goToPokemonDetail(pokemonId: Int, delegate: PokedexIOS.PokemonDetailDelegate) {
        return
    }
    
    func goToPokemonMoves(pokemonMoves: [PokedexIOS.PokemonMove], learnMethod: String) {
        return
    }
    
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    func start() {
        return
    }
    
    
}
