//
//  MoveRepresentable.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 25/1/24.
//

import Foundation

protocol MoveDTORepresentable {
    var id: Int { get }
    var name: String { get }
    var power: Int? { get }
    var pp: Int { get }
    var priority: Int { get }
    var accuracy: Int? { get }
    var damageClass: DamageClass { get }
    var effectChance: Int? { get }
    var effectEntries: [EffectEntries]? { get }
    var target: Target { get }
    var type: MoveType { get }
}

protocol DamageClassRepresentable {
    var name: String { get }
}

protocol EffectEntriesRepresentable {
    var effect: String { get }
}

protocol TargetRepresentable {
    var name: String { get }
}

protocol MoveTypeRepresentable {
    var name: String { get }
}
