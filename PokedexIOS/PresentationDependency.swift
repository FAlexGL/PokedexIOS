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
    func resolve(coordinator: MovesCoordinator) -> MovesListPresenter
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
        DefaultPokemonListPresenter(coordinator: coordinator, fetchPokemonsUseCase: resolve(), fetchFavouritesPokemonsUseCase: resolve())
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonDetailVC {
        PokemonDetailVC(presenter: resolve(coordinator: coordinator))
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonDetailPresenter {
//        DefaultPokemonDetailPresenter(apiHelper: _, dbHelper: _, coordinator: coordinator)
        fatalError()
    }
    
    func resolve(coordinator: MovesCoordinator) -> MovesListVC {
        MovesListVC(presenter: resolve(coordinator: coordinator))
    }
    
    func resolve(coordinator: MovesCoordinator) -> MovesListPresenter {
        // DefaultMovesListPresenter(dbHelper: resolve(), coordinator: coordinator)
        fatalError()
    }
    
    func resolve() -> MoveDetailPresenter {
        // DefaultMoveDetailPresenter(apiHelper: resolve())
        fatalError()
    }
    
    func resolve() -> MoveDetailVC {
        MoveDetailVC(presenter: resolve())
    }
}
