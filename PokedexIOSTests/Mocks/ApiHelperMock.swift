//
//  ApiHelperMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 31/1/24.
//

import Foundation
import Combine
import UIKit
@testable import PokedexIOS

final class ApiHelperMock: APIHelper {
    
    var pokemonListDTOMock = PokemonListDTO(next: "", previous: "", results: [])
    var pokemonDTOMock = PokemonDTO(id: 0, name: "", baseExperience: 0, height: 0, weight: 0, types: [], stats: [], sprites: Sprites(frontDefault: "", backDefault: nil, backFemale: nil, backShiny: nil, backShinyFemale: nil, frontFemale: nil, frontShiny: nil, frontShinyFemale: nil, other: Other(officialArtwork: OfficialArtwork(frontDefault: nil, frontShiny: nil))), moves: [])
    var moveDTOMock = MoveDTO(id: 0, name: "", power: 0, pp: 0, priority: 0, accuracy: 0, damageClass: DamageClass(name: ""), effectChance: 0, effectEntries: nil, target: Target(name: ""), type: MoveType(name: ""))
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListDTO, Error> {
        return Just(pokemonListDTOMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(pokemonIdOrName: String) -> AnyPublisher<PokemonDTO, Error> {
        return Just(pokemonDTOMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        return Just(moveDTOMock)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        completion(UIImage(named: Constants.Images.MISSINGNO)!)
    }
    
    
}
