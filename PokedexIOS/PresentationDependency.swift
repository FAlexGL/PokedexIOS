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
    func resolve(coordinator: PokemonCoordinator) -> PokemonDetailVC
    func resolve(coordinator: MovesCoordinator) -> MovesListVC
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
        PokemonListVC(coordinator: coordinator, apiHelper: resolve())
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonDetailVC {
        PokemonDetailVC(pokemonCoordinator: coordinator)
    }
    
    func resolve(coordinator: MovesCoordinator) -> MovesListVC {
        MovesListVC(coordinator: coordinator)
    }
    
    func resolve() -> MoveDetailVC {
        MoveDetailVC(nibName: Constants.NibNames.POKEMON_MOVE_DETAIL, bundle: nil)
    }
}
