//
//  DBHelper.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 12/12/23.
//

import Foundation
import RealmSwift

protocol DBHelper {
    func isFavourite(pokemonId: Int) -> Bool
    func fetchFavourites() -> [FavouritePokemon]
    func fetchFavouriteById(pokemonId: Int) -> FavouritePokemon?
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool
}

class DefaultDBHelper {
    
    static let shared = DefaultDBHelper()
    
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

extension DefaultDBHelper: DBHelper {
    
    func updateFavourite(favouritePokemon: FavouritePokemon) -> Bool {
        if isFavourite(pokemonId: favouritePokemon.pokemonId) {
            deleteFavourite(pokemonId: favouritePokemon.pokemonId)
        } else {
            saveFavourite(favouritePokemon: favouritePokemon)
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
    
    func fetchFavourites() -> [FavouritePokemon] {
        let realm = obtainRealm()
        if let favouritePokemons = realm?.objects(FavouritePokemon.self).sorted(byKeyPath: "pokemonId", ascending: true){
            return Array(favouritePokemons)
        }
        return []
    }
    
    func fetchFavouriteById(pokemonId: Int) -> FavouritePokemon? {
        let realm = obtainRealm()
        if let pokemon = realm?.object(ofType: FavouritePokemon.self, forPrimaryKey: pokemonId){
            return pokemon
        } else {
            return nil
        }
    }
    
    private func saveFavourite(favouritePokemon: FavouritePokemon) -> Bool{
        do {
            if let realm = obtainRealm(){
                try realm.write {
                    realm.add(favouritePokemon)
                    print("Favourite saved.")
                }
            }
            return true
        } catch {
            print("Error traying save favourite Pokemon: \(error)")
            return false
        }
    }
    
    private func deleteFavourite(pokemonId: Int) -> Bool {
        do {
            if let realm = obtainRealm(){
                if let pokemonToDelete = realm.object(ofType: FavouritePokemon.self, forPrimaryKey: pokemonId){
                    try realm.write{
                        realm.delete(pokemonToDelete)
                        print("Favourite deleted")
                    }
                }
            }
            return true
        } catch {
            print("Error trying to delete favourite Pokemon: \(error)")
            return false
        }
    }
}
