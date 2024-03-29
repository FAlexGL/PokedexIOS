//
//  MoveDetailPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/1/24.
//

import Foundation
import UIKit
import Combine

protocol MoveDetailViewDelegate {
    func didUpdatePokemonMove(moveDTORepresentable: MoveDTORepresentable)
    func didUpdateMoveData(moveData: [String : String], levelGames: NSMutableAttributedString)
}

protocol MoveDetailPresenter {
    var delegate: MoveDetailViewDelegate? { get set }
    func showData(moveDTORepresentable: MoveDTORepresentable, pokemonMove: PokemonMove?, learnMethod: String?)
    func getMoveDetail(moveName: String?)
}

class DefaultMoveDetailPresenter {
    var delegate: MoveDetailViewDelegate?
    private var apiHelper: APIHelper
    private let fetchPokemonUseCase: FetchPokemonsUseCase
    private var subscriptions = Set<AnyCancellable>()
    
    init(apiHelper: APIHelper, fetchPokemonUseCase: FetchPokemonsUseCase) {
        self.fetchPokemonUseCase = fetchPokemonUseCase
        self.apiHelper = apiHelper
    }
}

extension DefaultMoveDetailPresenter: MoveDetailPresenter {
    
    func showData(moveDTORepresentable: MoveDTORepresentable, pokemonMove: PokemonMove?, learnMethod: String?) {
        var result: [String : String] = [:]
        if let pokemonMove = pokemonMove, let learnMethod = learnMethod {
            result["name"] = (moveDTORepresentable.name).replacingOccurrences(of: "-", with: " ").uppercased()
            switch moveDTORepresentable.damageClassRepresentable.name {
            case "physical":
                result["damageClass"] = Constants.Images.PHYSICAL_MOVE
            case "special":
                result["damageClass"] = Constants.Images.SPECIAL_MOVE
            default:
                result["damageClass"] = Constants.Images.STATUS_MOVE
            }
            result["moveType"] = moveDTORepresentable.typeRepresentable.name
            if let effectEntries = moveDTORepresentable.effectEntriesRepresentable, effectEntries.count > 0 {
                result["description"] = effectEntries[0].effect.replacingOccurrences(of: "$effect_chance", with: "\(moveDTORepresentable.effectChance ?? -1)")
            }
            result["target"] = moveDTORepresentable.targetRepresentable.name.replacingOccurrences(of: "-", with: " ")
            result["power"] = "\(moveDTORepresentable.power ?? 0)"
            result["pp"] = "\(moveDTORepresentable.pp)"
            result["priority"] = "\(moveDTORepresentable.priority)"
            result["accuracy"] = "\(moveDTORepresentable.accuracy ?? 0)"
            var games: [Int : [String]] = [:]
            if let moves = pokemonMove.moves[learnMethod] {
                for move in moves {
                    if games.keys.contains(move.level){
                        games[move.level]?.append(move.game.replacingOccurrences(of: "-", with: " "))
                    } else {
                        games[move.level] = [move.game.replacingOccurrences(of: "-", with: " ")]
                    }
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
            delegate?.didUpdateMoveData(moveData: result, levelGames: levelGameStringAttribute)
        }
    }
    
    func getMoveDetail(moveName: String?) {
        if let moveName = moveName {
            fetchPokemonUseCase.fetchPokemonMove(urlString: moveName)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Pokemon's Move: '\(moveName)' fetched")
                    case .failure(let error):
                        print("Error decoding pokemon's move ',\(moveName): ' \(error)")
                    }
                } receiveValue: { moveDTO in
                    self.delegate?.didUpdatePokemonMove(moveDTORepresentable: moveDTO)
                }
                .store(in: &subscriptions)
            
        }
    }
}
