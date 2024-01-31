//
//  MoveDTOMock.swift
//  PokedexIOSTests
//
//  Created by Fernando Alejandro Garcia Lopez on 29/1/24.
//

import Foundation
@testable import PokedexIOS

struct MoveDTOMock: MoveDTORepresentable {
    var id: Int = 0
    var name: String = "Mock punch"
    var power: Int? = 0
    var pp: Int = 0
    var priority: Int = 0
    var accuracy: Int? = 0
    var damageClassRepresentable: DamageClassRepresentable = DamageClassMock()
    var effectChance: Int?
    var effectEntriesRepresentable: [EffectEntriesRepresentable]? = nil
    var targetRepresentable: TargetRepresentable = TargetMock()
    var typeRepresentable: MoveTypeRepresentable = TypeMock()
}

struct DamageClassMock: DamageClassRepresentable {
    var name: String = ""
}

struct EffectEntriesMock: EffectEntriesRepresentable {
    var effect: String = ""
}

struct TargetMock: TargetRepresentable {
    var name: String = ""
}

struct TypeMock: MoveTypeRepresentable {
    var name: String = ""
}
