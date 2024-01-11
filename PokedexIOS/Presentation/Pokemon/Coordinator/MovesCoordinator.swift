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
    private let presentationDependencies: PresentationDependency
    
    
    init(navigationController: UINavigationController, presentationDependencies: PresentationDependency) {
        self.navigationController = navigationController
        self.presentationDependencies = presentationDependencies
    }
    
    func start() {
        let movesListVC: MovesListVC = presentationDependencies.resolve(coordinator: self)
        if let pokemonModel = pokemonModel {
            movesListVC.setPokemonModel(pokemonModel: pokemonModel)
        }
        navigationController.pushViewController(movesListVC, animated: true)
    }
    
    func goToMoveDetail(moveName: String, levelsMove: PokemonModel.Move) {
        let moveDetailVC: MoveDetailVC = presentationDependencies.resolve()
        moveDetailVC.setMoves(moveName: moveName, levelsMove: levelsMove)
        navigationController.pushViewController(moveDetailVC, animated: true)
    }
}
