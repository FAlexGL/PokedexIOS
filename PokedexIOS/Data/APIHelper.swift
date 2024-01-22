//
//  APIHelper.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation
import UIKit
import Combine

protocol APIHelper {
    func fetchPokemonList(url: String)  -> AnyPublisher<PokemonListModel?, Never>
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveModel?, Never>
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

struct DefaultAPIHelper {
    
    static let shared = DefaultAPIHelper()
    
    private func performRequestPokemonList(urlString: String) -> AnyPublisher<PokemonListModel?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .map { parseJSONPokemonList($0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func performRequestPokemonDetail(urlString: String) -> AnyPublisher<PokemonModel?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .map { parseJSONPokemonDetail($0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func performRequestPokemonMove(urlString: String) -> AnyPublisher<MoveModel?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .map { parseJSONPokemonMove($0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
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
            return nil
        }
    }
    
}

extension DefaultAPIHelper: APIHelper {
    
    func fetchPokemonList(url: String)  -> AnyPublisher<PokemonListModel?, Never> {
        performRequestPokemonList(urlString: url)
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never> {
        performRequestPokemonDetail(urlString: "\(Constants.PokemonAPI.URL_POKEMON_DETAIL)\(pokemonId)")
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveModel?, Never> {
        performRequestPokemonMove(urlString: "\(Constants.PokemonAPI.URL_POKEMON_MOVE)\(urlString)")
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
