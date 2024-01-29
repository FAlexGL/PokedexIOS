//
//  MoveData.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 15/12/23.
//

import Foundation

struct MoveDTO: Decodable {
    let id: Int
    let name: String
    let power: Int?
    let pp: Int
    let priority: Int
    let accuracy: Int?
    let damageClass: DamageClass
    let effectChance: Int?
    let effectEntries: [EffectEntries]?
    let target: Target
    let type: MoveType
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case power = "power"
        case pp = "pp"
        case priority = "priority"
        case accuracy = "accuracy"
        case damageClass = "damage_class"
        case effectChance = "effect_chance"
        case effectEntries = "effect_entries"
        case target = "target"
        case type = "type"
    }
}

extension MoveDTO: MoveDTORepresentable {
    var damageClassRepresentable: DamageClassRepresentable {
        damageClass
    }
    
    var effectEntriesRepresentable: [EffectEntriesRepresentable]? {
        effectEntries
    }
    
    var targetRepresentable: TargetRepresentable {
        target
    }
    
    var typeRepresentable: MoveTypeRepresentable {
        type
    }
    
    
}

struct DamageClass: Decodable{
    let name: String
}

extension DamageClass: DamageClassRepresentable {
    
}

struct EffectEntries: Decodable{
    let effect: String
}

extension EffectEntries: EffectEntriesRepresentable {
    
}

struct Target: Decodable{
    let name: String
}

extension Target: TargetRepresentable {
    
}

struct MoveType: Decodable{
    let name: String
}

extension MoveType: MoveTypeRepresentable {
    
}
