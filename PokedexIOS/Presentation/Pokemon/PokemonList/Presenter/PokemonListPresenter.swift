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
    private let coordinator: PokemonCoordinator
    private let fetchPokemonsUseCase: FetchPokemonsUseCase
    private let fetchFavouritesPokemonsUseCase: FetchFavouritesPokemonsUseCase
    
    init(coordinator: PokemonCoordinator, fetchPokemonsUseCase: FetchPokemonsUseCase, fetchFavouritesPokemonsUseCase: FetchFavouritesPokemonsUseCase) {
        self.coordinator = coordinator
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.fetchFavouritesPokemonsUseCase = fetchFavouritesPokemonsUseCase
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
        fetchPokemonsUseCase.fetchPokemons { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.delegate?.didUpdatePokemonList(pokemonListModel: success)
            case .failure(let failure):
                self.delegate?.didFailWithError(error: failure)
            }
        }
    }
    
    func willDisplay(url: String) {
        fetchPokemonsUseCase.fetchPokemons(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.delegate?.didUpdatePokemonList(pokemonListModel: success)
            case .failure(let failure):
                self.delegate?.didFailWithError(error: failure)
            }
        }
    }
    
    func trailingSwipeActionsConfigurationForRowAt(pokemonId: Int, pokemonName: String, indexPath: IndexPath) {
//        var message = ""
//        var error = false
//        let isFavourite = dbHelper.isFavourite(pokemonId: pokemonId)
//        if isFavourite {
//            if !dbHelper.deleteFavourite(pokemonId: pokemonId) {
//                message = "Error deletting favourite, try again."
//                error = true
//            }
//        } else { 
//            if !dbHelper.saveFavourite(favouritePokemon: FavouritePokemon(pokemonId: pokemonId, pokemonName: pokemonName)) {
//                message = "Error adding favourite Pokemon, try again"
//                error = true
//            }
//        }
//        delegate?.favouriteChanged(error: error, message: message, indexPath: indexPath)
    }
    
    func favouriteButtonTapped() {
        let result = fetchFavouritesPokemonsUseCase.fetFavouritesPokemons()
        switch result {
        case .success(let success):
            delegate?.favouriteLoaded(pokemons: success)
        case .failure(let failure):
            self.delegate?.didFailWithError(error: failure)
        }
    }
}

//MARK: - Favourite delegate
extension DefaultPokemonListPresenter: PokemonDetailDelegate {
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        delegate?.favouriteUpdated(pokemonID: pokemonID, isFavourite: isFavourite)
    }
}
