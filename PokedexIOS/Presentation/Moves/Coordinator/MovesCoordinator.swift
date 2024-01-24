//
//  MovesCoordinator.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 20/12/23.
//

import Foundation
import UIKit

protocol MovesCoordinator: Coordinator {
    var pokemonMoves: [PokemonMove]? { get set }
    var learnMethod: String? { get set }
    func goToMoveDetail(moveName: String, pokemonMove: PokemonMove, learnMethod: String)
}

class DefaultMovesCoordinator: MovesCoordinator {
    
    var pokemonMoves: [PokemonMove]?
    var learnMethod: String?
    internal var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    private let presentationDependencies: PresentationDependency
    
    
    init(navigationController: UINavigationController, presentationDependencies: PresentationDependency) {
        self.navigationController = navigationController
        self.presentationDependencies = presentationDependencies
    }
    
    func start() {
        let movesListVC: MovesListVC = presentationDependencies.resolve(coordinator: self)
        if let pokemonMoves = pokemonMoves, let learnMethod = learnMethod {
            movesListVC.setPokemonMoves(pokemonMoves: pokemonMoves, learnMethod: learnMethod)
        }
        navigationController.pushViewController(movesListVC, animated: true)
    }
    
    func goToMoveDetail(moveName: String, pokemonMove: PokemonMove, learnMethod: String) {
        let moveDetailVC: MoveDetailVC = presentationDependencies.resolve()
        moveDetailVC.setMoves(pokemonMove: pokemonMove, learnMethod: learnMethod)
        navigationController.pushViewController(moveDetailVC, animated: true)
    }
}
