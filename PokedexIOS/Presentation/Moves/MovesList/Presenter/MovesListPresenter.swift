//
//  MovesListPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/1/24.
//

import Foundation
import UIKit

protocol MovesListPresenter {
    func numberOfRowsInSection(pokemonModel: PokemonModel?) -> Int
    func didSelectRowAt(pokemonModel: PokemonModel?, movePosition: Int)
    
}

class DefaultMovesListPresenter {
    private let dbHelper: DBHelper
    private let coordinator: MovesCoordinator
    
    init(dbHelper: DBHelper, coordinator: MovesCoordinator) {
        self.dbHelper = dbHelper
        self.coordinator = coordinator
    }
}

extension DefaultMovesListPresenter: MovesListPresenter {
    func numberOfRowsInSection(pokemonModel: PokemonModel?) -> Int {
        if let pokemonModel = pokemonModel{
            return pokemonModel.moves.count
        }
        return 0
    }
    
    func didSelectRowAt(pokemonModel: PokemonModel?, movePosition: Int) {
        if let pokemonModel = pokemonModel {
            coordinator.goToMoveDetail(moveName: pokemonModel.moves[movePosition].moveName, levelsMove: pokemonModel.moves[movePosition])
        }
    }
}

