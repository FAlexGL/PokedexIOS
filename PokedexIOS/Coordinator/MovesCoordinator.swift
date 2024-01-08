//
//  MovesCoordinator.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 20/12/23.
//

import Foundation
import UIKit

protocol MovesCoordinator: Coordinator {
    var pokemonModel: PokemonModel? { get set }
    func goToMoveDetail(moveName: String, levelsMove: PokemonModel.Move)
}

class DefaultMovesCoordinator: MovesCoordinator {
    var pokemonModel: PokemonModel?
    
    internal var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listMovesVC = MovesListVC(coordinator: self)
        if let pokemonModel = pokemonModel {
            listMovesVC.setPokemonModel(pokemonModel: pokemonModel)
        }
        navigationController.pushViewController(listMovesVC, animated: true)
    }
    
    func goToMoveDetail(moveName: String, levelsMove: PokemonModel.Move){
        let moveDetailVC = MoveDetailVC(nibName: K.NibNames.POKEMON_MOVE_DETAIL, bundle: nil)
        moveDetailVC.setMoves(moveName: moveName, levelsMove: levelsMove)
        navigationController.pushViewController(moveDetailVC, animated: true)
    }
}
