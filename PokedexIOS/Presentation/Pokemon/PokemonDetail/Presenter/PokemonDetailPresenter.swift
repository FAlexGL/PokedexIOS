//
//  PokemonDetailPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 10/1/24.
//

import Foundation
import UIKit

protocol PokemonDetailViewDelegate {
    func didUpdatePokemonDetail(pokemonModel: PokemonModel)
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
    func movesButtonPushed(pokemonModel: PokemonModel)
    func getPokemonDetail(pokemonId: Int)
    func downloadImage(urlString: String)
    func getSprites(pokemonSprites: PokemonModel.Sprites)
    func getTypesValues(types: [String])
    func switchChanged(_ sender: UISwitch, pokemonModel: PokemonModel?)
    func isFavourite(pokemonId: Int)
    func imageTapped(_ sender: UITapGestureRecognizer, sprites: [String], spritePosition: Int)
}

class DefaultPokemonDetailPresenter {
    var delegate: PokemonDetailViewDelegate?
    private var coordinator: PokemonCoordinator
    private var apiHelper: APIRepository
    private var dbHelper: DefaultDBHelper
    
    init(apiHelper: APIRepository, dbHelper: DefaultDBHelper, coordinator: PokemonCoordinator) {
        self.coordinator = coordinator
        self.apiHelper = apiHelper
        self.dbHelper = dbHelper
        self.apiHelper.delegate = self
    }
}

//MARK: - ext. PokemonDetailPresenter
extension DefaultPokemonDetailPresenter: PokemonDetailPresenter {
    func movesButtonPushed(pokemonModel: PokemonModel) {
        coordinator.goToPokemonMoves(pokemonModel: pokemonModel)
    }
    
    
    func isFavourite(pokemonId: Int) {
        let isFavourite = dbHelper.isFavourite(pokemonId: pokemonId)
        delegate?.setSwitchStatus(switchStatus: isFavourite)
    }
    
    func getSprites(pokemonSprites: PokemonModel.Sprites) {
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
        if let officialFront = pokemonSprites.officialFront{
            sprites.append(officialFront)
        }
        if let officialFrontShiny = pokemonSprites.officialFrontShiny {
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
        apiHelper.fetchPokemonDetail(pokemonId: pokemonId)
    }
    
    func switchChanged(_ sender: UISwitch, pokemonModel: PokemonModel?) {
        if let pokemonModel = pokemonModel {
            // Control error
            if sender.isOn{
                let favouritePokemon = FavouritePokemon(pokemonId: pokemonModel.pokemonId, pokemonName: pokemonModel.pokemonName)
                _ = dbHelper.saveFavourite(favouritePokemon: favouritePokemon)
            } else {
                _ = dbHelper.deleteFavourite(pokemonId: pokemonModel.pokemonId)
            }
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

//MARK: - Ext. APIHelperDelegate
extension DefaultPokemonDetailPresenter: APIHelperDelegate{
    func didFailWithError(error: Error) {
        //TODO: finalizar
    }
    
    func didUpdatePokemonDetail(pokemonModel: PokemonModel) {
        delegate?.didUpdatePokemonDetail(pokemonModel: pokemonModel)
    }
    
}
