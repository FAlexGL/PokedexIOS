//
//  PokemonDetailVCTests.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import XCTest
@testable import PokedexIOS

final class PokemonDetailVCTests: XCTestCase {
    
    var presenter: PokemonDetailPresenterMock!
    var pokemon: PokemonMock!
    var stats: [Stats]!
    var stat: Stat!
    var sprites: Sprites!
    var officialArtwork: OfficialArtwork!
    var other: Other!
    
    override func setUp() {
        presenter = PokemonDetailPresenterMock()
        stat = Stat(name: "Stat1", url: "https:www.stat1.com")
        stats = []
        other = Other(officialArtwork: OfficialArtwork(frontDefault: "", frontShiny: ""))
        sprites = Sprites(frontDefault: "", backDefault: "", backFemale: "", backShiny: "", backShinyFemale: "", frontFemale: "", frontShiny: "", frontShinyFemale: "", other: other)
        stats.append(Stats(baseStat: 0, stat: stat))
        pokemon = PokemonMock(id: 0, name: "MissingNo", baseExperience: 5, height: 4, weight: 3, types: [], stats: stats, sprites: sprites, moves: [])
        
    }
    
    //getStats(pokemonDTO: PokemonDTO) -> [(statName: String, baseStat: Int)]
    
    func test_Given_PokemonDetailVC_When_GetStatsIsCalled_Then_StatsArrayIsReturnedSuccessfully() {
        //Given
        let sut = PokemonDetailVC(presenter: presenter)
        
        //When
        let statsArray = sut.getStats(pokemonDTO: pokemon)
    }
    
    
    
}
