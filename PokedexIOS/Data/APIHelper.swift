//
//  APIHelper.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import Foundation
import UIKit
import Combine

protocol ModelType {
    init(data: Data)
}

protocol APIHelper {
    func fetchPokemonList(url: String)  -> AnyPublisher<PokemonListModel?, Never>
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveModel?, Never>
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

struct DefaultAPIHelper {
    
    static let shared = DefaultAPIHelper()
    
    private func performRequest<T: ModelType>(urlString: String) -> AnyPublisher<T?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        return URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .map { T.init(data: $0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
}

extension DefaultAPIHelper: APIHelper {
    
    func fetchPokemonList(url: String)  -> AnyPublisher<PokemonListModel?, Never> {
        performRequest(urlString: url)
    }
    
    func fetchPokemonDetail(pokemonId: Int) -> AnyPublisher<PokemonModel?, Never> {
        performRequest(urlString: "\(Constants.PokemonAPI.URL_POKEMON_DETAIL)\(pokemonId)")
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveModel?, Never> {
        performRequest(urlString: "\(Constants.PokemonAPI.URL_POKEMON_MOVE)\(urlString)")
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error converting URL object")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let image = UIImage(data: data){
                    completion(image)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
