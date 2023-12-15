//
//  MoveModel.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 15/12/23.
//

import Foundation

struct MoveModel {
    let id: Int
    let name: String
    let power: Int?
    let pp: Int
    let priority: Int
    let accuracy: Int?
    let effect_chance: Int?
    let damageClass: String
    let effect: String
    let target: String
    let moveType: String
}
