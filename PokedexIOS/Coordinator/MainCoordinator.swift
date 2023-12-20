//
//  MainCoordinator.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 19/12/23.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        navigationController.navigationBar.isTranslucent = false
//        navigationController.navigationBar.barTintColor = UIColor(named: K.Colours.BLUE_POKEMON_TITLE)
        
        
        let mainVC = PokemonListVC(nibName: K.NibNames.POKEMON_LIST, bundle: nil)
        navigationController.pushViewController(mainVC, animated: false)
    }
}
