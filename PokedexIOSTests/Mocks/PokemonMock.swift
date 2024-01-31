//
//  PokemonMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

@testable import PokedexIOS

struct PokemonMock: PokemonRepresentable {
    
    let id: Int = 1000
    let name: String = "missingno"
    let baseExperience: Int? = 0
    let height: Int = 0
    let weight: Int = 0
    var typesRepresentable: [TypesRepresentable] = [TypesMock()]
    var statsRepresentable: [StatsRepresentable] = [StatsMock()]
    var spritesRepresentable: SpritesRepresentable = SpritesMock()
    var movesRepresentable: [MovesRepresentable] = [MovesMock()]
}

struct TypesMock: TypesRepresentable {
    var slot: Int = 0
    var typeRepresentable: TypeRepresentable = TypePokemonMock()
}

struct TypePokemonMock: TypeRepresentable {
    var name: String = "Type Pokemon Mock"
    var url: String = "https://www.typePokemonMock.com"
}

struct StatsMock: StatsRepresentable {
    var baseStat: Int = 0
    var statRepresentable: StatRepresentable = StatMock()
    
}

struct StatMock: StatRepresentable {
    var name: String = "Stat Mock"
    var url: String = "https://www.statmockurl.com"
    
}

struct SpritesMock: SpritesRepresentable {
    var frontDefault: String = ""
    var backDefault: String? = nil
    var backFemale: String? = nil
    var backShiny: String? = nil
    var backShinyFemale: String? = nil
    var frontFemale: String? = nil
    var frontShiny: String? = nil
    var frontShinyFemale: String? = nil
    var otherRepresentable: OtherRepresentable = OtherMock()
}

struct OtherMock: OtherRepresentable {
    var officialArtworkRepresentable: OfficialArtworkRepresentable = OfficialArtworkMock()
}

struct OfficialArtworkMock: OfficialArtworkRepresentable {
    var frontDefault: String? = nil
    var frontShiny: String? = nil
}

struct MovesMock: MovesRepresentable {
    var moveRepresentable: MoveRepresentable = MoveMock()
    var versionGroupDetailsRepresentable: [VersionGroupDetailsRepresentable] = [VersionGroupDetailsMock()]
}

struct MoveMock: MoveRepresentable {
    var name: String = "Move Mock"
    var url: String = "https://www.moveMock.com"
}

struct VersionGroupDetailsMock: VersionGroupDetailsRepresentable {
    var levelLearnedAt: Int = 0
    var moveLearnMethodRepresentable: MoveLearnMethodRepresentable = MoveLearnMethodMock()
    var versionGroupRepresentable: VersionGroupRepresentable = VersionGroupMock()
    
}

struct MoveLearnMethodMock: MoveLearnMethodRepresentable {
    var name: String = "level mock"
}

struct VersionGroupMock: VersionGroupRepresentable {
    var name: String = "pokemon game mock"
}
