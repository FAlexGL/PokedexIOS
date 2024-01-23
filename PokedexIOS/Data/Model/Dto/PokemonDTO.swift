//
//  PokemonData.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation

//TODO: Rename: DTO(Data transfer object)
struct PokemonDTO: Decodable {
    let id: Int
    let name: String
    let base_experience: Int?
    let height: Int
    let weight: Int
    let types: [Types]
    let stats: [Stats]
    let sprites: Sprites
    let moves: [Moves]
}

struct Types: Decodable{
    let slot: Int
    let type: Type
}

struct Type: Decodable{
    let name: String
    let url: String
}

struct Stats: Decodable {
    let base_stat: Int
    let stat: Stat
}

struct Stat: Decodable{
    let name: String
    let url: String
}

struct Sprites: Decodable{
    let front_default: String
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_female: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    let other: Other
}

struct Moves: Decodable{
    let move: Move
    let version_group_details: [VersionGroupDetails]
}

struct Move: Decodable{
    let name: String
    let url: String
}

struct VersionGroupDetails: Decodable{
    let level_learned_at: Int
    let move_learn_method: MoveLearnMethod
    let version_group: VersionGroup
}

struct VersionGroup: Decodable{
    let name: String
}

struct MoveLearnMethod: Decodable{
    let name: String
}

struct Other: Decodable{
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
    case officialArtwork = "official-artwork"
    }
}

//struct OfficialArtwork: Decodable {
//    let frontDefault: String?
//    let frontShiny: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case frontDefault = "front_default"
//        case frontShiny = "front_shiny"
//    }
//}

struct OfficialArtwork: Decodable{
    let front_default: String?
    let front_shiny: String?
}
