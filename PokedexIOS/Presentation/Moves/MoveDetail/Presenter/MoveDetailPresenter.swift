//
//  MoveDetailPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/1/24.
//

import Foundation
import UIKit

protocol MoveDetailViewDelegate {
    func didUpdatePokemonMove(moveModel: MoveModel)
    func showData(moveData: [String : String], levelGames: NSMutableAttributedString)
}

protocol MoveDetailPresenter {
    var delegate: MoveDetailViewDelegate? { get set }
    func showData(moveModel: MoveModel, levelsMove: PokemonModel.Move?)
    func getMoveDetail(moveName: String?)
}

class DefaultMoveDetailPresenter {
    var delegate: MoveDetailViewDelegate?
    private var apiHelper: APIRepository
    
    init(apiHelper: APIRepository) {
        self.apiHelper = apiHelper
        self.apiHelper.delegate = self
    }
}

extension DefaultMoveDetailPresenter: MoveDetailPresenter {
    func showData(moveModel: MoveModel, levelsMove: PokemonModel.Move?) {
        var result: [String : String] = [:]
        if let levelsMove = levelsMove {
            result["name"] = (moveModel.name).replacingOccurrences(of: "-", with: " ").uppercased()
            switch moveModel.damageClass {
            case "physical":
                result["damageClass"] = Constants.Images.PHYSICAL_MOVE
            case "special":
                result["damageClass"] = Constants.Images.SPECIAL_MOVE
            default:
                result["damageClass"] = Constants.Images.STATUS_MOVE
            }
            result["moveType"] = moveModel.moveType
            result["description"] = moveModel.effect.replacingOccurrences(of: "$effect_chance", with: "\(moveModel.effectChance ?? -1)")
            result["target"] = moveModel.target.replacingOccurrences(of: "-", with: " ")
            result["power"] = "\(moveModel.power ?? 0)"
            result["pp"] = "\(moveModel.pp)"
            result["priority"] = "\(moveModel.priority)"
            result["accuracy"] = "\(moveModel.accuracy ?? 0)"
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
            delegate?.showData(moveData: result, levelGames: levelGameStringAttribute)
        }
    }
    
    func getMoveDetail(moveName: String?) {
        if let moveName = moveName {
            apiHelper.fetchMoveDetail(moveName: moveName)
        }
    }
}

extension DefaultMoveDetailPresenter: APIHelperDelegate {
    func didFailWithError(error: Error) {
        //TODO: TERMINAR
    }
    
    func didUpdatePokemonMove(moveModel: MoveModel) {
        delegate?.didUpdatePokemonMove(moveModel: moveModel)
    }
}
