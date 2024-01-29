//
//  PokemonData.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation

struct PokemonDTO: Decodable {
    let id: Int
    let name: String
    let baseExperience: Int?
    let height: Int
    let weight: Int
    let types: [Types]
    let stats: [Stats]
    let sprites: Sprites
    let moves: [Moves]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case baseExperience = "base_experience"
        case height = "height"
        case weight = "weight"
        case types = "types"
        case stats = "stats"
        case sprites = "sprites"
        case moves = "moves"
    }
}

extension PokemonDTO: PokemonRepresentable {
    var movesRepresentable: [MovesRepresentable] {
        moves
    }
    
    var spritesRepresentable: SpritesRepresentable {
        sprites
    }
    
    var statsRepresentable: [StatsRepresentable] {
        stats
    }
    
    var typesRepresentable: [TypesRepresentable] {
        types
    }
}

struct Types: Decodable, TypesRepresentable {
    let slot: Int
    let type: Type
}

struct Type: Decodable {
    let name: String
    let url: String
}

struct Stats: Decodable {
    let baseStat: Int
    let stat: Stat
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat = "stat"
    }
}

extension Stats: StatsRepresentable {
    var statRepresentable: StatRepresentable {
        stat
    }
}

struct Stat: Decodable, StatRepresentable {
    let name: String
    let url: String
}

struct Sprites: Decodable {
    let frontDefault: String
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    let other: Other
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other = "other"
    }
}

extension Sprites: SpritesRepresentable {
    var otherRepresentable: OtherRepresentable {
        other
    }
}

struct Other: Decodable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
    case officialArtwork = "official-artwork"
    }
}

extension Other: OtherRepresentable {
    var officialArtworkRepresentable: OfficialArtworkRepresentable {
        officialArtwork
    }
    
}

struct OfficialArtwork: Decodable, OfficialArtworkRepresentable {
    let frontDefault: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

struct Moves: Decodable {
    let move: Move
    let versionGroupDetails: [VersionGroupDetails]
    
    enum CodingKeys: String, CodingKey {
        case move = "move"
        case versionGroupDetails = "version_group_details"
    }
}

extension Moves: MovesRepresentable {
    var moveRepresentable: MoveRepresentable {
        move
    }
}

struct Move: Decodable, MoveRepresentable{
    let name: String
    let url: String
}

struct VersionGroupDetails: Decodable {
    let levelLearnedAt: Int
    let moveLearnMethod: MoveLearnMethod
    let versionGroup: VersionGroup
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

extension VersionGroupDetails: VersionGroupDetailsRepresentable {
    var moveLearnMethodRepresentable: MoveLearnMethodRepresentable {
        moveLearnMethod
    }
    
    var versionGroupRepresentable: VersionGroupRepresentable {
        versionGroup
    }
    
    
}

struct VersionGroup: Decodable, VersionGroupRepresentable {
    let name: String
}

struct MoveLearnMethod: Decodable, MoveLearnMethodRepresentable {
    let name: String
}
