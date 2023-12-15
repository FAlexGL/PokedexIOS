//
//  APIHelper.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation

enum ParseType {
    case pokemonList
    case pokemonDetail
}

protocol APIHelperDelegate {
    func didUpdatePokemonList(pokemonListModel: PokemonListModel)
    func didUpdatePokemonDetail(pokemonModel: PokemonModel)
    func didFailWithError(error: Error)
}

extension APIHelperDelegate {
    func didUpdatePokemonList(pokemonListModel: PokemonListModel){
    }
    func didUpdatePokemonDetail(pokemonModel: PokemonModel){
    }
}

struct APIHelper {
    
    var delegate: APIHelperDelegate?
    static let share = APIHelper()
    
    func fetchPokemonList(url: String){
        performRequest(with: url, type: .pokemonList)
    }
    
    func fetchPokemonDetail(pokemonId: Int){
        performRequest(with: "\(K.PokemonAPI.URL_POKEMON_DETAIL)\(pokemonId)", type: .pokemonDetail)
    }
    
    
    private func performRequest(with urlString: String, type: ParseType){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                print("Calling API...")
                if error != nil{
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
                    }
                }
            }
            task.resume()
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
        do{
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
//            var stats: [PokemonModel.Stat] = []
//            for stat in decodeData.stats {
//                let baseStat = stat.base_stat
//                let nameStat = stat.stat.name
//                let stat = PokemonModel.Stat(baseStat: baseStat, nameStat: nameStat)
//                stats.append(stat)
//            }
            var moves: [PokemonModel.Moves] = []
            for move in decodeData.moves {
                let moveName = move.move.name
                var moveVersionDetails: [(level: Int, game: String)] = []
                for moveVersion in move.version_group_details {
                    if moveVersion.level_learned_at > 0 {
                        moveVersionDetails.append((level: moveVersion.level_learned_at, game: moveVersion.version_group.name))
                    }
                }
                if moveVersionDetails.count > 0 {
                    moves.append(PokemonModel.Moves(moveName: moveName, moveVersionDetails: moveVersionDetails))
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
            let sprites = PokemonModel.Sprites(frontDefault: frontDefault, backDefault: backDefault, backFemale: backFemale, backShiny: backShiny, backShinyFemale: backShinyFemale, frontFemale: frontFemale, frontShiny: frontShiny, frontShinyFemale: frontShinyFemale)
            
            return PokemonModel(pokemonId: pokemonId, pokemonName: pokemonName, baseExperience: baseExperience, height: height, weight: weight, types: types, stats: stats, sprites: sprites, moves: moves)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

