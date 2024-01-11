//
//  MovesListPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/1/24.
//

import Foundation
import UIKit

protocol MovesListViewDelegate {
    
}

protocol MovesListPresenter {
    var delegate: MovesListViewDelegate? { get set }
    
}

class DefaultMovesListPresenter {
    var delegate: MovesListViewDelegate?
    let dbHelper: DBHelper
    
    init(dbHelper: DBHelper) {
        self.dbHelper = dbHelper
    }
}

extension DefaultMovesListPresenter: MovesListPresenter {
    
}

