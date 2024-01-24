//
//  MovesListPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/1/24.
//

import Foundation
import UIKit

protocol MovesListPresenter {
    func numberOfRowsInSection(pokemonMoves: [PokemonMove]?) -> Int
    func didSelectRowAt(pokemonMoves: [PokemonMove]?, movePosition: Int, learnMethod: String?)
    
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
    
    func numberOfRowsInSection(pokemonMoves: [PokemonMove]?) -> Int {
        if let pokemonMoves = pokemonMoves{
            return pokemonMoves.count
        }
        return 0
    }
    
    func didSelectRowAt(pokemonMoves: [PokemonMove]?, movePosition: Int, learnMethod: String?) {
        if let pokemonMoves = pokemonMoves, let learnMethod = learnMethod {
            coordinator.goToMoveDetail(moveName: pokemonMoves[movePosition].moveName, pokemonMove: pokemonMoves[movePosition], learnMethod: learnMethod)
        }
    }
}

