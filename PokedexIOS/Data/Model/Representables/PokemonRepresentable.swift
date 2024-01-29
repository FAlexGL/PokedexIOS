//
//  PokemonRepresentable.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import Foundation

protocol PokemonRepresentable {
    var id: Int { get }
    var name: String { get }
    var baseExperience: Int? { get }
    var height: Int { get }
    var weight: Int { get }
    var typesRepresentable: [TypesRepresentable] { get }
    var statsRepresentable: [StatsRepresentable] { get }
    var spritesRepresentable: SpritesRepresentable { get }
    var movesRepresentable: [MovesRepresentable] { get }
}

protocol TypesRepresentable {
    var slot: Int { get }
    var type: Type { get }
}

protocol TypeRepresentable {
    var name: String { get }
    var url: String { get }
}

protocol StatsRepresentable {
    var baseStat: Int { get }
    var statRepresentable: StatRepresentable { get }
}

protocol StatRepresentable {
    var name: String { get }
    var url: String { get }
}

protocol SpritesRepresentable {
    var frontDefault: String { get }
    var backDefault: String? { get }
    var backFemale: String? { get }
    var backShiny: String? { get }
    var backShinyFemale: String? { get }
    var frontFemale: String? { get }
    var frontShiny: String? { get }
    var frontShinyFemale: String? { get }
    var otherRepresentable: OtherRepresentable { get }
}

protocol OtherRepresentable {
    var officialArtworkRepresentable: OfficialArtworkRepresentable { get }
}

protocol OfficialArtworkRepresentable {
    var frontDefault: String? { get }
    var frontShiny: String? { get }
}

protocol MovesRepresentable {
    var moveRepresentable: MoveRepresentable { get }
    var versionGroupDetails: [VersionGroupDetails] { get }
}

protocol MoveRepresentable {
    var name: String { get }
    var url: String { get }
}

protocol VersionGroupDetailsRepresentable {
    var levelLearnedAt: Int { get }
    var moveLearnMethodRepresentable: MoveLearnMethodRepresentable { get }
    var versionGroupRepresentable: VersionGroupRepresentable { get }
}

protocol VersionGroupRepresentable{
    var name: String { get }
}

protocol MoveLearnMethodRepresentable{
    var name: String { get }
}
