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
    let effectChance: Int?
    let damageClass: String
    let effect: String
    let target: String
    let moveType: String    
}

extension MoveModel: ModelType {
    init(data: Data) {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(MoveData.self, from: data)
            self.id = decodeData.id
            self.name = decodeData.name
            self.power = decodeData.power
            self.pp = decodeData.pp
            self.priority = decodeData.priority
            self.accuracy = decodeData.accuracy
            self.effectChance = decodeData.effect_chance
            self.damageClass = decodeData.damage_class.name
            self.effect = decodeData.effect_entries[0].effect
            self.target = decodeData.target.name
            self.moveType = decodeData.type.name
        } catch {
            self.id = -1
            self.name = "ERROR MOVE"
            self.power = 0
            self.pp = 0
            self.priority = 0
            self.accuracy = 0
            self.effectChance = 0
            self.damageClass = ""
            self.effect = ""
            self.target = ""
            self.moveType = ""
            print("error\(error)")
        }
    }
    
    
}
