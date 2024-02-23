//
//  PokemonFavourite.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation
import RealmSwift

// TODO: Rename to Entity
class FavouritePokemon: Object {
    @Persisted(primaryKey: true) var pokemonId: Int
    @Persisted var pokemonName: String
    
    convenience init(pokemonId: Int, pokemonName: String) {
        self.init()
        self.pokemonId = pokemonId
        self.pokemonName = pokemonName
    }
}

//class PokemonEntity: Object {
//    @Persisted var id: Int = 0
//    @Persisted var name: String = ""
//    @Persisted var baseExperience: Int? = 0
//    @Persisted var height: Int = 0
//    @Persisted var weight: Int = 0
//    @Persisted var types = List<TypesEntity>()
//}
//
//extension PokemonEntity: PokemonRepresentable {
//    var typesRepresentable: [TypesRepresentable] {
//        Array(types)
//    }
//    
//    var statsRepresentable: [StatsRepresentable] {
//        []
//    }
//    
//    var spritesRepresentable: SpritesRepresentable {
//        Sprites(frontDefault: <#T##String#>, backDefault: <#T##String?#>, backFemale: <#T##String?#>, backShiny: <#T##String?#>, backShinyFemale: <#T##String?#>, frontFemale: <#T##String?#>, frontShiny: <#T##String?#>, frontShinyFemale: <#T##String?#>, other: <#T##Other#>)
//    }
//    
//    var movesRepresentable: [MovesRepresentable] {
//        []
//    }
//    
//    
//}
//
//class TypesEntity: Object {
//    @Persisted var slot: Int = 0
//    @Persisted var type: TypeEntity = TypeEntity()
//}
//
//extension TypesEntity: TypesRepresentable {
//    var typeRepresentable: TypeRepresentable {
//        type
//    }
//}
//
//class TypeEntity: Object {
//    @Persisted var name: String = ""
//    @Persisted var url: String = ""
//}
//
//extension TypeEntity: TypeRepresentable {
//    
//}
