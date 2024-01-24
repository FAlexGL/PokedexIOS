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
    func goToMoveDetail(moveName: String, pokemonMove: PokemonMove)
}

class DefaultMovesCoordinator: MovesCoordinator {
    
    var pokemonMoves: [PokemonMove]?
    internal var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    private let presentationDependencies: PresentationDependency
    
    
    init(navigationController: UINavigationController, presentationDependencies: PresentationDependency) {
        self.navigationController = navigationController
        self.presentationDependencies = presentationDependencies
    }
    
    func start() {
        let movesListVC: MovesListVC = presentationDependencies.resolve(coordinator: self)
        if let pokemonMoves = pokemonMoves {
            movesListVC.setPokemonMoves(pokemonMoves: pokemonMoves)
        }
        navigationController.pushViewController(movesListVC, animated: true)
    }
    
    func goToMoveDetail(moveName: String, pokemonMove: PokemonMove) {
        let moveDetailVC: MoveDetailVC = presentationDependencies.resolve()
        moveDetailVC.setMoves(moveName: moveName, pokemonMove: pokemonMove)
        navigationController.pushViewController(moveDetailVC, animated: true)
    }
}
