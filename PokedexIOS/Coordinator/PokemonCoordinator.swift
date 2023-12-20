//
//  MainCoordinator.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 19/12/23.
//

import Foundation
import UIKit

protocol PokemonCoordinator: Coordinator {
    func goToPokemonDetail(pokemonId: Int, delegate: PokemonDetailDelegate)
    func goToPokemonMoves(pokemonModel: PokemonModel)
}

class DefaultPokemonCoordinator: PokemonCoordinator {
    internal var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(){
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let mainVC = PokemonListVC(coordinator: self)
        navigationController.pushViewController(mainVC, animated: false)
    }
    
    func goToPokemonDetail(pokemonId: Int, delegate: PokemonDetailDelegate){
        let pokemonDetailVC = PokemonDetailVC(pokemonCoordinator: self)
        pokemonDetailVC.setPokemonId(pokemonId: pokemonId)
        pokemonDetailVC.delegate = delegate
        navigationController.pushViewController(pokemonDetailVC, animated: true)
    }
    
    func goToPokemonMoves(pokemonModel: PokemonModel){
        var movesCoordinator: MovesCoordinator = DefaultMovesCoordinator(navigationController: self.navigationController)
        movesCoordinator.pokemonModel = pokemonModel
        movesCoordinator.start()
    }
}
