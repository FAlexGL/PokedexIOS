//
//  PokemonDetailPresenter.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 10/1/24.
//

import Foundation
import UIKit
import Combine

enum PokemonDetailState {
    case idle
    case pokemonLoaded(PokemonRepresentable)
    case spritesLoaded([String])
    case favouriteUpdated(Bool)
    case imageLoaded(UIImage)
    case typesValuesLoaded([String : Double])
}

protocol PokemonDetailPresenter {
    var statePublisher: AnyPublisher<PokemonDetailState, Never> { get }
    func movesButtonPushed(pokemonMoves: [PokemonMove], learnMethod: String)
    func getPokemonDetail(pokemonName: String?, pokemonDetail: PokemonRepresentable?)
    func downloadImage(urlString: String)
    func getSprites(pokemonSprites: SpritesRepresentable)
    func getTypesValues(types: [String])
    func switchChanged(_ sender: UISwitch, pokemonDTO: PokemonRepresentable?)
    func isFavourite(pokemonId: Int)
    func imageTapped(_ sender: UITapGestureRecognizer, sprites: [String])
    func imageSwapper(sprites: [String])
}

class DefaultPokemonDetailPresenter {
    private var subscriptions = Set<AnyCancellable>()
    private var coordinator: PokemonCoordinator
    private var apiHelper: APIHelper
    private let fetchPokemonsUseCase: FetchPokemonsUseCase
    private let updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase
    private let fetchFavouritesPokemonsUseCase: FetchFavouritePokemonsUseCase
    private var spritePosition: Int
    private var imageSwappingTimer: Timer?
    private var imagesCache: [UIImage]
    
    private var stateSubject = CurrentValueSubject<PokemonDetailState, Never>(.idle)
    public var statePublisher: AnyPublisher<PokemonDetailState, Never> {
        stateSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    init(apiHelper: APIHelper, coordinator: PokemonCoordinator, fetchPokemonsUseCase: FetchPokemonsUseCase, updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase, fetchFavouritesPokemonsUseCase: FetchFavouritePokemonsUseCase) {
        self.coordinator = coordinator
        self.apiHelper = apiHelper
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.updateFavouritePokemonsUseCase = updateFavouritePokemonsUseCase
        self.fetchFavouritesPokemonsUseCase = fetchFavouritesPokemonsUseCase
        spritePosition = 1
        imageSwappingTimer = nil
        imagesCache = []
    }
}

//MARK: - ext. PokemonDetailPresenter
extension DefaultPokemonDetailPresenter: PokemonDetailPresenter {
    
    func movesButtonPushed(pokemonMoves: [PokemonMove], learnMethod: String) {
        coordinator.goToPokemonMoves(pokemonMoves: pokemonMoves, learnMethod: learnMethod)
    }
    
    
    func isFavourite(pokemonId: Int) {
        let favouritePokemons = fetchFavouritesPokemonsUseCase.fetchFavouritePokemons()
        switch favouritePokemons {
        case .success(let pokemons):
            if pokemons.contains(where: { $0.pokemonId == pokemonId }) {
                stateSubject.send(.favouriteUpdated(true))
            }
        case .failure(_):
            print("Error searching favourite Pokemons")
        }
    }
    
    func getSprites(pokemonSprites: SpritesRepresentable) {
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
        if let officialFront = pokemonSprites.otherRepresentable.officialArtworkRepresentable.frontDefault{
            sprites.append(officialFront)
        }
        if let officialFrontShiny = pokemonSprites.otherRepresentable.officialArtworkRepresentable.frontShiny {
            sprites.append(officialFrontShiny)
        }
        stateSubject.send(.spritesLoaded(sprites))
        print("Total sprites: \(sprites.count)")
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
            stateSubject.send(.typesValuesLoaded(typesValues))
        }
        
    }
    
    func downloadImage(urlString: String) {
        apiHelper.downloadImage(from: urlString)
            .sink { image in
                self.stateSubject.send(.imageLoaded(image))
                self.imagesCache.append(image)
            }
            .store(in: &subscriptions)
    }
    
    
    func getPokemonDetail(pokemonName: String?, pokemonDetail: PokemonRepresentable?) {
        guard let pokemonName = pokemonName else {
            return
        }
        
        if let pokemonDetail = pokemonDetail {
            stateSubject.send(.pokemonLoaded(pokemonDetail))
        } else {
            fetchPokemonsUseCase.fetchPokemonDetail(pokemonIdOrName: pokemonName)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Pokemon's detail fetched")
                case .failure(_):
                    print("Error fetching Pokemon's Detail")
                }
            }, receiveValue: { self.stateSubject.send(.pokemonLoaded($0)) })
            .store(in: &subscriptions)
            }
    }
    
    func switchChanged(_ sender: UISwitch, pokemonDTO: PokemonRepresentable?) {
        if let pokemonDTO = pokemonDTO {
            let favouritePokemon = FavouritePokemon(pokemonId: pokemonDTO.id, pokemonName: pokemonDTO.name)
            _ = updateFavouritePokemonsUseCase.updateFavourite(favouritePokemon: favouritePokemon)
            stateSubject.send(.favouriteUpdated(sender.isOn))
        }
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer, sprites: [String]) {
        if let imageSwappingTimer = imageSwappingTimer {
            imageSwappingTimer.isValid ? imageSwappingTimer.invalidate() : imageSwapper(sprites: sprites)
        }
    }
    
    func imageSwapper(sprites: [String]) {
        imageSwappingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if self.imagesCache.count != sprites.count  && sprites.count > 1{
                self.downloadImage(urlString: sprites[self.spritePosition])
                print("image downloaded")
            } else if sprites.count > 1 {
                self.stateSubject.send(.imageLoaded(self.imagesCache[self.spritePosition]))
                print("image from cache")
            }
            self.spritePosition < sprites.count-1 ? (self.spritePosition += 1) : (self.spritePosition = 0)
        }
    }
}
