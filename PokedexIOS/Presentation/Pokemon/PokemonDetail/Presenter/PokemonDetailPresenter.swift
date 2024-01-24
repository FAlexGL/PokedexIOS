//
//  PokemonDetailPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 10/1/24.
//

import Foundation
import UIKit
import Combine

protocol PokemonDetailViewDelegate: AnyObject {
    func didUpdatePokemonDetail(pokemonDTO: PokemonDTO)
    func didFailWithError(error: Error)
    func showImage(image: UIImage)
    func didUpdateSprites(spritesArray: [String])
    func typesValuesFetched(types: [String: Double])
    func setFavourite(isFavourite: Bool)
    func setSwitchStatus(switchStatus: Bool)
    func setSpritePosition(spritePosition: Int)
}

protocol PokemonDetailPresenter {
    var delegate: PokemonDetailViewDelegate? { get set }
    func movesButtonPushed(pokemonMoves: [PokemonMove])
    func getPokemonDetail(pokemonId: Int)
    func downloadImage(urlString: String)
    func getSprites(pokemonSprites: Sprites)
    func getTypesValues(types: [String])
    func switchChanged(_ sender: UISwitch, pokemonDTO: PokemonDTO?)
    func isFavourite(pokemonId: Int)
    func imageTapped(_ sender: UITapGestureRecognizer, sprites: [String], spritePosition: Int)
}

class DefaultPokemonDetailPresenter {
    weak var delegate: PokemonDetailViewDelegate?
    private var subscriptions: [AnyCancellable] = []
    private var coordinator: PokemonCoordinator
    private var apiHelper: APIHelper
    private let fetchPokemonsUseCase: FetchPokemonsUseCase
    private let updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase
    private let fetchFavouritesPokemonsUseCase: FetchFavouritesPokemonsUseCase
    
    init(apiHelper: APIHelper, coordinator: PokemonCoordinator, fetchPokemonsUseCase: FetchPokemonsUseCase, updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase, fetchFavouritesPokemonsUseCase: FetchFavouritesPokemonsUseCase) {
        self.coordinator = coordinator
        self.apiHelper = apiHelper
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.updateFavouritePokemonsUseCase = updateFavouritePokemonsUseCase
        self.fetchFavouritesPokemonsUseCase = fetchFavouritesPokemonsUseCase
    }
}

//MARK: - ext. PokemonDetailPresenter
extension DefaultPokemonDetailPresenter: PokemonDetailPresenter {
    
    func movesButtonPushed(pokemonMoves: [PokemonMove]) {
        coordinator.goToPokemonMoves(pokemonMoves: pokemonMoves)
    }
    
    
    func isFavourite(pokemonId: Int) {
        let favouritePokemons = fetchFavouritesPokemonsUseCase.fetchFavouritesPokemons()
        switch favouritePokemons {
        case .success(let pokemons):
            if pokemons.contains(where: { $0.pokemonId == pokemonId }) {
                delegate?.setSwitchStatus(switchStatus: true)
            }
        case .failure(_):
            print("Error searching favourite Pokemons")
        }
    }
    
    func getSprites(pokemonSprites: Sprites) {
        var sprites: [String] = []
        
        sprites.append(pokemonSprites.frontDefault)
        if let backDefault = pokemonSprites.backDefault {
            sprites.append(backDefault)
        }
        if let backFemale = pokemonSprites.backFemale {
            sprites.append(backFemale)
        }
        if let backShiny = pokemonSprites.backShiny {
            sprites.append(backShiny)
        }
        if let backShinyFemale = pokemonSprites.backShinyFemale{
            sprites.append(backShinyFemale)
        }
        if let frontFemale = pokemonSprites.frontFemale {
            sprites.append(frontFemale)
        }
        if let frontShiny = pokemonSprites.frontShiny {
            sprites.append(frontShiny)
        }
        if let frontShinyFemale = pokemonSprites.frontShinyFemale {
            sprites.append(frontShinyFemale)
        }
        if let officialFront = pokemonSprites.other.officialArtwork.frontDefault{
            sprites.append(officialFront)
        }
        if let officialFrontShiny = pokemonSprites.other.officialArtwork.frontShiny {
            sprites.append(officialFrontShiny)
        }
        delegate?.didUpdateSprites(spritesArray: sprites)
    }
    
    func getTypesValues(types: [String]) {
        var typesValues: [String: Double] = ["normal": 0.1, "fighting": 0.1, "flying": 0.1, "poison": 0.1, "ground": 0.1, "rock": 0.1,
                                             "bug": 0.1, "ghost": 0.1, "steel": 0.1, "fire": 0.1, "water": 0.1, "grass": 0.1, "electric": 0.1,
                                             "psychic": 0.1, "ice": 0.1, "dragon": 0.1, "dark": 0.1, "fairy": 0.1]
        for type in types {
            switch type {
            case "normal":
                typesValues["normal"] = 1.0
            case "fighting":
                typesValues["fighting"] = 1.0
            case "flying":
                typesValues["flying"] = 1.0
            case "poison":
                typesValues["poison"] = 1.0
            case "ground":
                typesValues["ground"] = 1.0
            case "rock":
                typesValues["rock"] = 1.0
            case "bug":
                typesValues["bug"] = 1.0
            case "ghost":
                typesValues["ghost"] = 1.0
            case "steel":
                typesValues["steel"] = 1.0
            case "fire":
                typesValues["fire"] = 1.0
            case "water":
                typesValues["water"] = 1.0
            case "grass":
                typesValues["grass"] = 1.0
            case "electric":
                typesValues["electric"] = 1.0
            case "psychic":
                typesValues["psychic"] = 1.0
            case "ice":
                typesValues["ice"] = 1.0
            case "dragon":
                typesValues["dragon"] = 1.0
            case "dark":
                typesValues["dark"] = 1.0
            case "fairy":
                typesValues["fairy"] = 1.0
            default:
                print("error con el typo: \(type)")
            }
            delegate?.typesValuesFetched(types: typesValues)
        }
        
    }
    
    func downloadImage(urlString: String) {
        apiHelper.downloadImage(from: urlString) { [weak self] (image) in
            guard let self = self else {return}
            var imageReturned: UIImage
            if let image = image {
                imageReturned = image
            } else {
                imageReturned = UIImage(named: Constants.Images.MISSINGNO)! // ¿POR QUÉ ES OPCIONAL??????
            }
            delegate?.showImage(image: imageReturned)
        }
    }
    
    
    func getPokemonDetail(pokemonId: Int) {
        fetchPokemonsUseCase.fetchPokemonDetail(pokemonId: pokemonId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Pokemon's detail fetched")
                case .failure(_):
                    print("Error fetching Pokemon's Detail")
                }
            }, receiveValue: { self.delegate?.didUpdatePokemonDetail(pokemonDTO: $0) })
            .store(in: &subscriptions)
    }
    
    func switchChanged(_ sender: UISwitch, pokemonDTO: PokemonDTO?) {
        if let pokemonDTO = pokemonDTO {
            let favouritePokemon = FavouritePokemon(pokemonId: pokemonDTO.id, pokemonName: pokemonDTO.name)
            _ = updateFavouritePokemonsUseCase.updateFavourite(favouritePokemon: favouritePokemon)
            delegate?.setFavourite(isFavourite: sender.isOn)
        }
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer, sprites: [String], spritePosition: Int) {
        downloadImage(urlString: sprites[spritePosition])
        var nextSpritePosition = spritePosition
        if spritePosition < sprites.count-1{
            nextSpritePosition += 1
        } else {
            nextSpritePosition = 0
        }
        delegate?.setSpritePosition(spritePosition: nextSpritePosition)
    }
    
}
