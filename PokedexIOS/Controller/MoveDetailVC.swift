//
//  MoveDetailVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 14/12/23.
//

import UIKit

class MoveDetailVC: UIViewController {
    @IBOutlet weak private var moveNameLabel: UILabel!
    @IBOutlet weak private var imageMoveClass: UIImageView!
    @IBOutlet weak private var descriptionTextView: UITextView!
    @IBOutlet weak private var targetLabel: UILabel!
    @IBOutlet weak private var powerLabel: UILabel!
    @IBOutlet weak private var ppLabel: UILabel!
    @IBOutlet weak private var priorityLabel: UILabel!
    @IBOutlet weak private var accuracyLabel: UILabel!
    @IBOutlet weak var imageMoveType: UIImageView!
    @IBOutlet weak var levelGamesTextView: UITextView!
    
    //constant info views
    @IBOutlet weak var descriptionCILable: UILabel!
    @IBOutlet weak var targetCILable: UILabel!
    @IBOutlet weak var powerCILable: UILabel!
    @IBOutlet weak var ppCILable: UILabel!
    @IBOutlet weak var priorityCILable: UILabel!
    @IBOutlet weak var accuracyCILable: UILabel!
    @IBOutlet weak var learnedAtCILable: UILabel!
    
    private var moveModel: MoveModel?
    private var levelsMove: PokemonModel.Moves?
    private var effectChance = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateViews()
    }
    
    func setMoves(moveModel: MoveModel, levelsMove:PokemonModel.Moves){
        self.moveModel = moveModel
        self.levelsMove = levelsMove
        showData()
    }
    
    private func translateViews(){
        let descriptionString = NSLocalizedString("Description", comment: "")
        let targetString = NSLocalizedString("Target", comment: "")
        let powerString = NSLocalizedString("Power", comment: "")
        let priorityString = NSLocalizedString("Priority", comment: "")
        let accuracyString = NSLocalizedString("Accuracy", comment: "")
        let learnedAtString = NSLocalizedString("LearnedAt", comment: "")
        
        descriptionCILable.text = descriptionString
        targetCILable.text = targetString
        powerCILable.text = powerString
        priorityCILable.text = priorityString
        accuracyCILable.text = accuracyString
        learnedAtCILable.text = learnedAtString
    }
    
    private func showData(){
        DispatchQueue.main.async {
            if let levelsMove = self.levelsMove, let moveModel = self.moveModel {
                self.moveNameLabel.text = (moveModel.name).replacingOccurrences(of: "-", with: " ").uppercased()
                switch moveModel.damageClass {
                case "physical":
                    self.imageMoveClass.image = UIImage(named: K.Images.PHYSICAL_MOVE)
                case "special":
                    self.imageMoveClass.image = UIImage(named: K.Images.SPECIAL_MOVE)
                default:
                    self.imageMoveClass.image = UIImage(named: K.Images.STATUS_MOVE)
                }
                self.imageMoveType.image = UIImage(named: moveModel.moveType)
                self.descriptionTextView.text = moveModel.effect.replacingOccurrences(of: "$effect_chance", with: "\(moveModel.effectChance ?? -1)")
                self.targetLabel.text = moveModel.target.replacingOccurrences(of: "-", with: " ")
                self.powerLabel.text = "\(moveModel.power ?? 0)"
                self.ppLabel.text = "\(moveModel.pp)"
                self.priorityLabel.text = "\(moveModel.priority)"
                self.accuracyLabel.text = "\(moveModel.accuracy ?? 0)"
                var games: [Int : [String]] = [:]
                for move in levelsMove.moveVersionDetails{
                    if games.keys.contains(move.level){
                        games[move.level]?.append(move.game.replacingOccurrences(of: "-", with: " "))
                    } else {
                        games[move.level] = [move.game.replacingOccurrences(of: "-", with: " ")]
                    }
                }
                let levelGamesOrdered = games.sorted { $0.key < $1.key}
                let levelGameStringAttribute = NSMutableAttributedString(string: "")
                for levelGames in levelGamesOrdered{
                    let level = NSAttributedString(string: "Level \(levelGames.key):\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: K.Colours.BLUE_POKEMON_TITLE) ?? UIColor.blue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)])
                    levelGameStringAttribute.append(level)
                    for game in levelGames.value {
                        let gameTitle = NSAttributedString(string: "\u{2022} \(game)\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19)])
                        levelGameStringAttribute.append(gameTitle)
                    }
                }
                self.levelGamesTextView.attributedText = levelGameStringAttribute
            }
        }
    }
}
