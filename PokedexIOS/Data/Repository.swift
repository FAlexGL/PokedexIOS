//
//  Repository.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 15/1/24.
//

import Foundation
import UIKit

protocol APIRepository {
    var delegate: APIHelperDelegate? { get set}
    
    func fetchPokemonList(url: String)
    func fetchPokemonDetail(pokemonId: Int)
    func fetchMoveDetail(moveName: String)
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

protocol DBRepository {
    associatedtype T
    
    func saveFavourite(favouritePokemon: T) -> Bool
    func isFavourite(pokemonId: Int) -> Bool
    func deleteFavourite(pokemonId: Int)  -> Bool
    func fetchFavourites() -> [(Int, String)]
    func fetchFavouriteById(pokemonId: Int) -> T?
}



