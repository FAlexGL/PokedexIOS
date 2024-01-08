//
//  PresentationDependency.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 8/1/24.
//

import Foundation

protocol PresentationDependency {
    func resolve() -> PokemonCoordinator
    func resolve(coordinator: PokemonCoordinator) -> PokemonListVC
}

extension PresentationDependency where Self: DefaultAppDependency {
    func resolve() -> PokemonCoordinator {
        DefaultPokemonCoordinator(presentationDependencies: self)
    }
    
    func resolve(coordinator: PokemonCoordinator) -> PokemonListVC {
        PokemonListVC(coordinator: coordinator, apiHelper: resolve())
    }
}
