//
//  PokemonListModel.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation

struct PokemonListModel {
    var nextURL: String = ""
    var previousURL: String?
    var pokemons: [String] = []
    //TODO: hacer algo
//    let pokemons: [PokemonItemModel]
    
}

struct PokemonItemModel {
    let pokemonId: Int
    let pokemonName: String
    let isFavourite: Bool
}

extension PokemonListModel: ModelType {
    init(data: Data) {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(PokemonListData.self, from: data)
            self.nextURL = decodeData.next ?? ""
            self.previousURL = decodeData.previous ?? ""
            self.pokemons = []
            for pokemon in decodeData.results{
                pokemons.append(pokemon.name)
            }
        } catch {
            print("Parsing PokemonListModel error")
        }
    }
}
