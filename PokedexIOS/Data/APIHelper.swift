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

enum NetError: Error {
    case badUrl
}

protocol APIHelper {
    func fetchPokemonList(url: String)  -> AnyPublisher<PokemonListDTO, Error>
    func fetchPokemonDetail(pokemonIdOrName: String) -> AnyPublisher<PokemonDTO, Error>
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error>
    func downloadImage(from urlString: String) -> AnyPublisher<UIImage, Never>
}

struct DefaultAPIHelper {
    
    static let shared = DefaultAPIHelper()
    
    func performRequest<T: Decodable>(urlString: String) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: urlString) else {
                fatalError("converting URL error")
            }
        
            return URLSession(configuration: .default)
                .dataTaskPublisher(for: url)
                .retry(3)
                .map({ data, response in
                    return data
                })
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
}

extension DefaultAPIHelper: APIHelper {
    
    
    func fetchPokemonList(url: String) -> AnyPublisher<PokemonListDTO, Error> {
        performRequest(urlString: url)
    }
    
    func fetchPokemonDetail(pokemonIdOrName: String) -> AnyPublisher<PokemonDTO, Error> {
        performRequest(urlString: "\(Constants.PokemonAPI.URL_POKEMON_DETAIL)\(pokemonIdOrName)")
    }
    
    func fetchPokemonMove(urlString: String) -> AnyPublisher<MoveDTO, Error> {
        performRequest(urlString: "\(Constants.PokemonAPI.URL_POKEMON_MOVE)\(urlString)")
    }
    
    func downloadImage(from urlString: String) -> AnyPublisher<UIImage, Never> {
        guard let url = URL(string: urlString) else {
            print("Error converting URL object")
            return Just(UIImage(named: Constants.Images.MISSINGNO)!)
                .eraseToAnyPublisher()
        }
        
        return URLSession(configuration: .default)
            .dataTaskPublisher(for: url)
            .retry(3)
            .map({ data, response in
                return data
            })
            .map { (UIImage(data: $0) ?? UIImage(named: Constants.Images.MISSINGNO)!) }
            .replaceError(with: UIImage(named: Constants.Images.MISSINGNO)!)
            .eraseToAnyPublisher()
    }
}
