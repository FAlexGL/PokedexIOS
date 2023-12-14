//
//  MoveDetailVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 14/12/23.
//

import UIKit

class MoveDetailVC: UIViewController {
    @IBOutlet weak var moveNameLabel: UILabel!
    @IBOutlet weak var gameAndLevelMove: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showData(move: PokemonModel.Moves){
        DispatchQueue.main.async {
            self.moveNameLabel.text = (move.moveName).uppercased()

            var moveInfoString = ""
            for move in move.moveVersionDetails{
                moveInfoString.append("\(move.game.replacingOccurrences(of: "-", with: " ")):\n     -Level: \(move.level)\n\n")
            }
            self.gameAndLevelMove.text = moveInfoString
        }
    }
}
