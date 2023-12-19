//
//  ErrorVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import UIKit

class ErrorVC: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonPusshed(_ sender: UIButton) {
        let pokemonListVC = PokemonListVC(nibName: K.NibNames.POKEMON_LIST, bundle: nil)
        pokemonListVC.resetApp()
        navigationController?.pushViewController(pokemonListVC, animated: true)
    }
}
