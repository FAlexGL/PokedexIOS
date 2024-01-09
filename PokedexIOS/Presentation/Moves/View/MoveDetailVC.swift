//
//  MoveDetailVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 14/12/23.
//

import UIKit

class MoveDetailVC: UIViewController {
    @IBOutlet private weak var moveNameLabel: UILabel!
    @IBOutlet private weak var imageMoveClass: UIImageView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var targetLabel: UILabel!
    @IBOutlet private weak var powerLabel: UILabel!
    @IBOutlet private weak var ppLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!
    @IBOutlet private weak var accuracyLabel: UILabel!
    @IBOutlet weak var imageMoveType: UIImageView!
    @IBOutlet weak var levelGamesTextView: UITextView!
    
    //constant info views
    @IBOutlet private weak var descriptionCILable: UILabel!
    @IBOutlet private weak var targetCILable: UILabel!
    @IBOutlet private weak var powerCILable: UILabel!
    @IBOutlet private weak var ppCILable: UILabel!
    @IBOutlet private weak var priorityCILable: UILabel!
    @IBOutlet private weak var accuracyCILable: UILabel!
    @IBOutlet private weak var learnedAtCILable: UILabel!
    
    private var moveModel: MoveModel?
    private var levelsMove: PokemonModel.Move?
    private var effectChance = 0
    private var moveName: String?
    private var apiHelper: APIHelper = DefaultAPIHelper.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiHelper.delegate = self
        translateViews()
        getMoveDetail()
    }
    
    func setMoves(moveName: String, levelsMove: PokemonModel.Move){
        self.moveName = moveName
        self.levelsMove = levelsMove
    }
    
    private func getMoveDetail(){
        if let moveName = moveName {
            apiHelper.fetchMoveDetail(moveName: moveName)
        }
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
    
    private func showData(moveModel: MoveModel){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let levelsMove = self.levelsMove {
                self.moveNameLabel.text = (moveModel.name).replacingOccurrences(of: "-", with: " ").uppercased()
                switch moveModel.damageClass {
                case "physical":
                    self.imageMoveClass.image = UIImage(named: Constants.Images.PHYSICAL_MOVE)
                case "special":
                    self.imageMoveClass.image = UIImage(named: Constants.Images.SPECIAL_MOVE)
                default:
                    self.imageMoveClass.image = UIImage(named: Constants.Images.STATUS_MOVE)
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
                for levelGames in levelGamesOrdered {
                    let level = NSAttributedString(string: "Level \(levelGames.key):\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE) ?? UIColor.blue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)])
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

extension MoveDetailVC: APIHelperDelegate{
    func didFailWithError(error: Error) {
        print("error: \(error)")
    }
    func didUpdatePokemonMove(moveModel: MoveModel) {
        showData(moveModel: moveModel)
    }
}
