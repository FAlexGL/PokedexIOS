//
//  DBHelper.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation
import RealmSwift

protocol DBHelperProtocol {
    func saveFavourite(favouritePokemon: FavouritePokemon)
    func isFavourite(pokemonId: Int) -> Bool
    func deleteFavourite(pokemonId: Int)
    func fetchFavourites() -> [(Int, String)]
}

class DBHelper {
    
    static let shared = DBHelper()
    
    private func obtainRealm() -> Realm? {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch {
            print("Error obtaining Realm: \(error)")
        }
        return realm
    }
}

extension DBHelper: DBHelperProtocol{
    func saveFavourite(favouritePokemon: FavouritePokemon){
        do {
            if let realm = obtainRealm(){
                try realm.write {
                    realm.add(favouritePokemon)
                    print("Favourite saved.")
                }
            }
        } catch {
            print("Error traying save favourite Pokemon: \(error)")
        }
    }
    
    func isFavourite(pokemonId: Int) -> Bool {
        let realm = obtainRealm()
        if let _ = realm?.object(ofType: FavouritePokemon.self, forPrimaryKey: pokemonId){
            return true
        } else {
            return false
        }
    }
    
    func deleteFavourite(pokemonId: Int){
        do {
            if let realm = obtainRealm(){
                if let pokemonToDelete = realm.object(ofType: FavouritePokemon.self, forPrimaryKey: pokemonId){
                    try realm.write{
                        realm.delete(pokemonToDelete)
                        print("Favourite deleted")
                    }
                }
            }
        } catch {
            print("Error trying to delete favourite Pokemon: \(error)")
        }
    }
    
    func fetchFavourites() -> [(Int, String)] {
        var result: [(pokemonID: Int, pokemonName: String)] = []
        let realm = obtainRealm()
        if let objetos = realm?.objects(FavouritePokemon.self).sorted(byKeyPath: "pokemonId", ascending: true){
            for objeto in objetos {
                result.append((pokemonID: objeto.pokemonId, pokemonName: objeto.pokemonName))
            }
        }
        return result
    }
}

