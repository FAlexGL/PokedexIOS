//
//  PokemonMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

@testable import PokedexIOS

struct PokemonMock: PokemonRepresentable {
    let id: Int = 0
    let name: String = "MissingNo"
    let baseExperience: Int? = 0
    let height: Int = 0
    let weight: Int = 0
    let types: [Types] = []
    let stats: [Stats] = []
    let sprites: Sprites = Sprites(frontDefault: "", backDefault: "", backFemale: "", backShiny: "", backShinyFemale: "", frontFemale: "", frontShiny: "", frontShinyFemale: "", other: Other(officialArtwork: OfficialArtwork(frontDefault: "", frontShiny: "")))
    let moves: [Moves] = []
}
