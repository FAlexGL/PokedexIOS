//
//  APIHelper.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation
import UIKit

enum ParseType {
    case pokemonList
    case pokemonDetail
    case pokemonMove
}

protocol APIHelperDelegate {
    func didUpdatePokemonList(pokemonListModel: PokemonListModel)
    func didUpdatePokemonDetail(pokemonModel: PokemonModel)
    func didUpdatePokemonMove(moveModel: MoveModel)
    func didFailWithError(error: Error)
}

extension APIHelperDelegate {
    func didUpdatePokemonList(pokemonListModel: PokemonListModel) {}
    func didUpdatePokemonDetail(pokemonModel: PokemonModel) {}
    func didUpdatePokemonMove(moveModel: MoveModel) {}
}

protocol APIHelper {
    var delegate: APIHelperDelegate? { get set}
    func fetchPokemonList(url: String)
    func fetchPokemonDetail(pokemonId: Int)
    func fetchMoveDetail(moveName: String)
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

struct DefaultAPIHelper {
    
    var delegate: APIHelperDelegate?
    static let share = DefaultAPIHelper()
    
    private func performRequest(with urlString: String, type: ParseType) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                print("Calling API...")
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    switch type {
                    case .pokemonList:
                        if let pokemonListModel = parseJSONPokemonList(safeData){
                            delegate?.didUpdatePokemonList(pokemonListModel: pokemonListModel)
                        }
                    case .pokemonDetail:
                        if let pokemonModel = parseJSONPokemonDetail(safeData) {
                            delegate?.didUpdatePokemonDetail(pokemonModel: pokemonModel)
                        }
                    case .pokemonMove:
                        if let moveModel = parseJSONPokemonMove(safeData){
                            delegate?.didUpdatePokemonMove(moveModel: moveModel)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSONPokemonMove(_ moveData: Data) -> MoveModel? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(MoveData.self, from: moveData)
            let id = decodeData.id
            let name = decodeData.name
            let power = decodeData.power
            let pp = decodeData.pp
            let priority = decodeData.priority
            let accuracy = decodeData.accuracy
            let effectChance = decodeData.effect_chance
            let damageClass = decodeData.damage_class.name
            let effect = decodeData.effect_entries[0].effect
            let target = decodeData.target.name
            let type = decodeData.type.name
            let moveModel = MoveModel(id: id, name: name, power: power, pp: pp, priority: priority, accuracy: accuracy, effectChance: effectChance, damageClass: damageClass, effect: effect, target: target, moveType: type)
            return moveModel
        } catch {
            print("error\(error)")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func parseJSONPokemonList(_ pokemonListData: Data) -> PokemonListModel? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(PokemonListData.self, from: pokemonListData)
            let nextURL = decodeData.next ?? ""
            let previousURL = decodeData.previous ?? ""
            var pokemons: [String] = []
            for pokemon in decodeData.results{
                pokemons.append(pokemon.name)
            }
            let pokemonListModel = PokemonListModel(nextURL: nextURL, previousURL: previousURL, pokemons: pokemons)
            return pokemonListModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func parseJSONPokemonDetail(_ pokemonDetailData: Data) -> PokemonModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonDetailData)
            let pokemonId = decodeData.id
            let pokemonName = decodeData.name
            var baseExperience = -1
            if let baseExperienceContent = decodeData.base_experience { //some Pokemons doesnt have base experience
                baseExperience = baseExperienceContent
            }
            let height = decodeData.height
            let weight = decodeData.weight
            var types: [String] = []
            for type in decodeData.types {
                types.append(type.type.name)
            }
            var stats: [(statName:String, baseStat:Int)] = []
            for stat in decodeData.stats {
                let stat = (statName: stat.stat.name, baseStat: stat.base_stat)
                stats.append(stat)
            }
            var moves: [PokemonModel.Move] = []
            for move in decodeData.moves {
                let moveName = move.move.name
                let moveURL = move.move.url
                var moveVersionDetails: [(level: Int, game: String)] = []
                for moveVersion in move.version_group_details {
                    if moveVersion.move_learn_method.name == "level-up" {
                        moveVersionDetails.append((level: moveVersion.level_learned_at, game: moveVersion.version_group.name))
                    }
                }
                if moveVersionDetails.count > 0 {
                    moves.append(PokemonModel.Move(moveName: moveName, moveURL: moveURL, learnMethod: "level-up", moveVersionDetails: moveVersionDetails))
                }
            }
            //Sprites
            let frontDefault = decodeData.sprites.front_default
            let backDefault = decodeData.sprites.back_default ?? nil
            let backFemale = decodeData.sprites.back_female ?? nil
            let backShiny = decodeData.sprites.back_shiny ?? nil
            let backShinyFemale = decodeData.sprites.back_shiny_female ?? nil
            let frontFemale = decodeData.sprites.front_female ?? nil
            let frontShiny = decodeData.sprites.front_shiny ?? nil
            let frontShinyFemale = decodeData.sprites.front_shiny_female ?? nil
            let officialFront = decodeData.sprites.other.officialArtwork.front_default ?? nil
            let officialFrontShiny = decodeData.sprites.other.officialArtwork.front_shiny ?? nil
            let sprites = PokemonModel.Sprites(frontDefault: frontDefault, backDefault: backDefault, backFemale: backFemale, backShiny: backShiny, backShinyFemale: backShinyFemale, frontFemale: frontFemale, frontShiny: frontShiny, frontShinyFemale: frontShinyFemale, officialFront: officialFront, officialFrontShiny: officialFrontShiny)
            
            return PokemonModel(pokemonId: pokemonId, pokemonName: pokemonName, baseExperience: baseExperience, isFavourite: false, height: height, weight: weight, types: types, stats: stats, sprites: sprites, moves: moves)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

extension DefaultAPIHelper: APIHelper {
    func fetchPokemonList(url: String) {
        performRequest(with: url, type: .pokemonList)
    }
    
    func fetchPokemonDetail(pokemonId: Int) {
        performRequest(with: "\(Constants.PokemonAPI.URL_POKEMON_DETAIL)\(pokemonId)", type: .pokemonDetail)
    }
    
    func fetchMoveDetail(moveName: String) {
        performRequest(with: "\(Constants.PokemonAPI.URL_POKEMON_MOVE)\(moveName)", type: .pokemonMove)
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error converting URL object")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let image = UIImage(data: data){
                    completion(image)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
