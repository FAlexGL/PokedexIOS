//
//  MainCoordinator.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 19/12/23.
//

import Foundation
import UIKit

protocol PokemonCoordinator: Coordinator {
    func goToPokemonDetail(pokemonName: String, delegate: PokemonDetailDelegate, pokemonDetail: PokemonRepresentable?)
    func goToPokemonMoves(pokemonMoves: [PokemonMove], learnMethod: String)
}

class DefaultPokemonCoordinator: PokemonCoordinator {
    internal var childCoordinator: [Coordinator] = []
    internal var navigationController: UINavigationController
    private let presentationDependencies: PresentationDependency
    
    init(presentationDependencies: PresentationDependency){
        self.presentationDependencies = presentationDependencies
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let mainVC: PokemonListVC = presentationDependencies.resolve(coordinator: self)
        navigationController.pushViewController(mainVC, animated: false)
    }
    
    func goToPokemonDetail(pokemonName: String, delegate: PokemonDetailDelegate, pokemonDetail: PokemonRepresentable?){
        let pokemonDetailVC: PokemonDetailVC = presentationDependencies.resolve(coordinator: self)
        pokemonDetailVC.setPokemonData(pokemonName: pokemonName, pokemonDetail: pokemonDetail)
        pokemonDetailVC.delegate = delegate
        navigationController.pushViewController(pokemonDetailVC, animated: true)
    }
    
    func goToPokemonMoves(pokemonMoves: [PokemonMove], learnMethod: String){
        var movesCoordinator: MovesCoordinator = presentationDependencies.resolve(navigationController: navigationController)
        movesCoordinator.pokemonMoves = pokemonMoves
        movesCoordinator.learnMethod = learnMethod
        movesCoordinator.start()
    }
}
