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
            var stats: [PokemonModel.Stat] = []
            for stat in decodeData.stats {
                let baseStat = stat.base_stat
                let nameStat = stat.stat.name
                let stat = PokemonModel.Stat(baseStat: baseStat, nameStat: nameStat)
                stats.append(stat)
            }
            let spriteURL = decodeData.sprites.front_default
            return PokemonModel(pokemonId: pokemonId, pokemonName: pokemonName, baseExperience: baseExperience, height: height, weight: weight, types: types, stats: stats, spriteURL: spriteURL)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

