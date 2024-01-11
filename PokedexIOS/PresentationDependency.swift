//
//  PresentationDependency.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 8/1/24.
//

import Foundation
import UIKit

protocol PresentationDependency {
    func resolve() -> PokemonCoordinator
    func resolve(navigationController: UINavigationController) -> MovesCoordinator
    func resolve(coordinator: PokemonCoordinator) -> PokemonListVC
    func resolve(coordinator: PokemonCoordinator) -> PokemonListPresenter
    func resolve(coordinator: PokemonCoordinator) -> PokemonDetailVC
    func resolve(coordinator: MovesCoordinator) -> MovesListVC
    func resolve(coordinator: PokemonCoordinator) -> MovesListPresenter
    func resolve() -> MoveDetailVC
}

extension PresentationDependency where Self: DefaultAppDependency {

    func resolve() -> PokemonCoordinator {
        DefaultPokemonCoordinator(presentationDependencies: self)
    }
    
    func resolve(navigationController: UINavigationController) -> MovesCoordinator {
        DefaultMovesCoordinator(navigationController: navigationController, presentationDependencies: self)
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonListVC {
        PokemonListVC(presenter: resolve(coordinator: coordinator))
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonListPresenter {
        DefaultPokemonListPresenter(apiHelper: resolve(), dbHelper: resolve(), coordinator: coordinator)
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonDetailVC {
        PokemonDetailVC(presenter: resolve(coordinator: coordinator))
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonDetailPresenter {
        DefaultPokemonDetailPresenter(apiHelper: resolve(), dbHelper: resolve(), coordinator: resolve())
    }
    
    func resolve(coordinator: MovesCoordinator) -> MovesListVC {
        MovesListVC(presenter: resolve(coordinator: resolve()))
    }
    
    func resolve(coordinator: PokemonCoordinator) -> MovesListPresenter {
        DefaultMovesListPresenter(dbHelper: resolve())
    }
    
    func resolve() -> MoveDetailVC {
        MoveDetailVC(nibName: Constants.NibNames.POKEMON_MOVE_DETAIL, bundle: nil)
    }
}
