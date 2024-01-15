//
//  PokemonListPresenter.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 9/1/24.
//

import Foundation

protocol PokemonListViewDelegate {
    func didUpdatePokemonList(pokemonListModel: PokemonListModel)
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool)
    func favouriteLoaded(pokemons: [(pokemonID: Int, pokemonName: String)])
    func favouriteChanged(error: Bool, message: String, indexPath: IndexPath)
    func didFailWithError(error: Error)
}

protocol PokemonListPresenter {
    var delegate: PokemonListViewDelegate? { get set }
    func viewDidLoad()
    func willDisplay(url: String)
    func trailingSwipeActionsConfigurationForRowAt(pokemonId: Int, pokemonName: String, indexPath: IndexPath)
    func favouriteButtonTapped()
    func didSelectRowAt(pokemonId: Int)
    func didSelectRowAt(pokemonModel: PokemonModel)
}

class DefaultPokemonListPresenter {
    var delegate: PokemonListViewDelegate?
    private var apiHelper: APIRepository
    private let dbHelper: DefaultDBHelper
    private let coordinator: PokemonCoordinator
    
    init(apiHelper: APIRepository, dbHelper: DefaultDBHelper, coordinator: PokemonCoordinator) {
        self.apiHelper = apiHelper
        self.dbHelper = dbHelper
        self.coordinator = coordinator
        self.apiHelper.delegate = self
    }
}


//MARK: - Presenter delegate
extension DefaultPokemonListPresenter: PokemonListPresenter {
    
    func didSelectRowAt(pokemonId: Int) {
        coordinator.goToPokemonDetail(pokemonId: pokemonId, delegate: self)
    }
    
    func didSelectRowAt(pokemonModel: PokemonModel) {
        
    }
    
    func viewDidLoad() {
        apiHelper.fetchPokemonList(url: Constants.PokemonAPI.URL_POKEMON_LIST)
    }
    
    func willDisplay(url: String) {
        apiHelper.fetchPokemonList(url: url)
    }
    
    func trailingSwipeActionsConfigurationForRowAt(pokemonId: Int, pokemonName: String, indexPath: IndexPath) {
        var message = ""
        var error = false
        let isFavourite = dbHelper.isFavourite(pokemonId: pokemonId)
        if isFavourite {
            if !dbHelper.deleteFavourite(pokemonId: pokemonId) {
                message = "Error deletting favourite, try again."
                error = true
            }
        } else {
            if !dbHelper.saveFavourite(favouritePokemon: FavouritePokemon(pokemonId: pokemonId, pokemonName: pokemonName)) {
                message = "Error adding favourite Pokemon, try again"
                error = true
            }
        }
        delegate?.favouriteChanged(error: error, message: message, indexPath: indexPath)
    }
    
    func favouriteButtonTapped() {
        delegate?.favouriteLoaded(pokemons: dbHelper.fetchFavourites())
    }
}

//MARK: - Api delegate
extension DefaultPokemonListPresenter: APIHelperDelegate {
    
    func didUpdatePokemonList(pokemonListModel: PokemonListModel) {
        delegate?.didUpdatePokemonList(pokemonListModel: pokemonListModel)
    }
    
    func didFailWithError(error: Error) {
        delegate?.didFailWithError(error: error)
    }
    
}

//MARK: - Favourite delegate
extension DefaultPokemonListPresenter: PokemonDetailDelegate {
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        delegate?.favouriteUpdated(pokemonID: pokemonID, isFavourite: isFavourite)
    }
}
