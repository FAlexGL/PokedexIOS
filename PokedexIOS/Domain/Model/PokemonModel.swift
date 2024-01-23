//
//  PokemonModel.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation

struct PokemonModel {
    let pokemonId: Int
    let pokemonName: String
    let baseExperience: Int
//    let isFavourite: Bool
    let height: Int
    let weight: Int
    var types: [String]
    var stats: [(statName:String, baseStat:Int)]
    let sprites: Sprites
    var moves: [Move]
    
    struct Move {
        let moveName: String
        let moveURL: String
        let learnMethod: String
        let moveVersionDetails: [(level: Int, game: String)]
    }
    
    struct Sprites {
        let frontDefault: String
        let backDefault: String?
        let backFemale: String?
        let backShiny: String?
        let backShinyFemale: String?
        let frontFemale: String?
        let frontShiny: String?
        let frontShinyFemale: String?
        let officialFront: String?
        let officialFrontShiny: String?
    }
}

extension PokemonModel: ModelType {
    init(data: Data) {
        
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(PokemonDTO.self, from: data)
            self.pokemonId = decodeData.id
            self.pokemonName = decodeData.name
            if let baseExperienceContent = decodeData.base_experience { //some Pokemons doesnt have base experience
                self.baseExperience = baseExperienceContent
            } else {
                self.baseExperience = -1
            }
            self.height = decodeData.height
            self.weight = decodeData.weight
            self.types = []
            for type in decodeData.types {
                self.types.append(type.type.name)
            }
            self.stats = []
            for stat in decodeData.stats {
                let stat = (statName: stat.stat.name, baseStat: stat.base_stat)
                self.stats.append(stat)
            }
            self.moves = []
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
                    self.moves.append(PokemonModel.Move(moveName: moveName, moveURL: moveURL, learnMethod: "level-up", moveVersionDetails: moveVersionDetails))
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
            self.sprites = PokemonModel.Sprites(frontDefault: frontDefault, backDefault: backDefault, backFemale: backFemale, backShiny: backShiny, backShinyFemale: backShinyFemale, frontFemale: frontFemale, frontShiny: frontShiny, frontShinyFemale: frontShinyFemale, officialFront: officialFront, officialFrontShiny: officialFrontShiny)
        } catch {
            self.pokemonId = -1
            self.pokemonName = "MissingNo"
            self.baseExperience = -1
            self.height = 0
            self.weight = 0
            self.types = []
            self.stats = []
            self.moves = []
            //Sprites
            let frontDefault = "\(Constants.PokemonAPI.URL_POKEMON_IMAGE)0.png"
            self.sprites = PokemonModel.Sprites(frontDefault: frontDefault, backDefault: nil, backFemale: nil, backShiny: nil, backShinyFemale: nil, frontFemale: nil, frontShiny: nil, frontShinyFemale: nil, officialFront: nil, officialFrontShiny: nil)
            print("error")
        }
    }
}
