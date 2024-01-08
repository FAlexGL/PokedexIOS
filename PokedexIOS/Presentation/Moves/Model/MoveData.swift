//
//  MoveData.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 15/12/23.
//

import Foundation

struct MoveData: Decodable {
    let id: Int
    let name: String
    let power: Int?
    let pp: Int
    let priority: Int
    let accuracy: Int?
    let damage_class: DamageClass
    let effect_chance: Int?
    let effect_entries: [EffectEntries]
    let target: Target
    let type: MoveType
}

struct DamageClass: Decodable{
    let name: String
}

struct EffectEntries: Decodable{
    let effect: String
}

struct Target: Decodable{
    let name: String
}

struct MoveType: Decodable{
    let name: String
}
