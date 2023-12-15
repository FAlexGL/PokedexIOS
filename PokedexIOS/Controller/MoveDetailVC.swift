//
//  MoveDetailVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 14/12/23.
//

import UIKit

class MoveDetailVC: UIViewController {
    @IBOutlet weak private var moveNameLabel: UILabel!
    @IBOutlet weak private var gameAndLevelMove: UITextView!
    private var moveModel: MoveModel?
    private var levelsMove: PokemonModel.Moves?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
    }
    
    func setMoves(moveModel: MoveModel, levelsMove:PokemonModel.Moves){
        self.moveModel = moveModel
        self.levelsMove = levelsMove
    }
    
    func showData(){
        DispatchQueue.main.async {
            if let levelsMove = self.levelsMove, let moveModel = self.moveModel {
                self.moveNameLabel.text = (moveModel.name).uppercased()
                var moveInfoString = ""
                for move in levelsMove.moveVersionDetails{
                    moveInfoString.append("\(move.game.replacingOccurrences(of: "-", with: " ")):\n     -Level: \(move.level)\n\n")
                }
                self.gameAndLevelMove.text = moveInfoString
            }
        }
    }
}
