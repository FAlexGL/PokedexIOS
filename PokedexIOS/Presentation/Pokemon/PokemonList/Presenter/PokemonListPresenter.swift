//
//  PokemonListPresenter.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 9/1/24.
//

import Foundation
import UIKit

protocol PokemonListViewDelegate {
    func didUpdatePokemonList(pokemonListModel: PokemonListModel)
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool)
    func favouriteLoaded(pokemons: [FavouritePokemon])
    func favouriteChanged(error: Bool, message: String, indexPath: IndexPath)
    func didFailWithError(error: Error)
}

protocol PokemonListPresenter {
    var delegate: PokemonListViewDelegate? { get set }
    func didSelectRowAt(showFavouritesButtonTitle: String?, indexPath: IndexPath, favouritePokemonsFetched: [FavouritePokemon])
    func viewDidLoad()
    func willDisplay(showFavouritesButtonTitle: String?, totalRows: Int, indexPath: IndexPath, url: String)
    func numberOfRowsInSection (showFavouritesButtonTitle: String?, favouritePokemonsFetched: Int, pokemonsFetched: Int) -> Int
    func cellForRowAt (tableView: UITableView, indexPath: IndexPath, showFavouritesButtonTitle: String?, favouritePokemonsFetched: [FavouritePokemon], pokemonsFetched: [String]) -> UITableViewCell
    func trailingSwipeActionsConfigurationForRowAt(pokemonId: Int, pokemonName: String, indexPath: IndexPath)
    func favouriteButtonTapped(showFavouritesButtonTitle: String?) -> String?
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
    
    func didSelectRowAt(showFavouritesButtonTitle: String?, indexPath: IndexPath, favouritePokemonsFetched: [FavouritePokemon]) {
        let pokemonId: Int
        if showFavouritesButtonTitle == NSLocalizedString("ShowAll", comment: "") {
            pokemonId = favouritePokemonsFetched[indexPath.row].pokemonId
        } else {
            pokemonId = indexPath.row + 1
        }
        coordinator.goToPokemonDetail(pokemonId: pokemonId, delegate: self)
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
    
    func willDisplay(showFavouritesButtonTitle: String?, totalRows: Int, indexPath: IndexPath, url: String) {
        if showFavouritesButtonTitle != NSLocalizedString("ShowAll", comment: "") {
            if indexPath.row == totalRows - 1 && url != "" {
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
        }
    }
    
    func numberOfRowsInSection (showFavouritesButtonTitle: String?, favouritePokemonsFetched: Int, pokemonsFetched: Int) -> Int {
        if showFavouritesButtonTitle == NSLocalizedString("ShowAll", comment: "") {
            return favouritePokemonsFetched
        }
        return pokemonsFetched
    }
    
    func cellForRowAt (tableView: UITableView, indexPath: IndexPath, showFavouritesButtonTitle: String?, favouritePokemonsFetched: [FavouritePokemon], pokemonsFetched: [String]) -> UITableViewCell {
        if showFavouritesButtonTitle == NSLocalizedString("ShowAll", comment: "") {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER, for: indexPath) as! PokemonCell
            cell.showData(pokemonID: favouritePokemonsFetched[indexPath.row].pokemonId, pokemonName: favouritePokemonsFetched[indexPath.row].pokemonName)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER, for: indexPath) as! PokemonCell
        cell.showData(pokemonID: indexPath.row + 1, pokemonName: pokemonsFetched[indexPath.row])
        return cell
    }
    
    func trailingSwipeActionsConfigurationForRowAt(pokemonId: Int, pokemonName: String, indexPath: IndexPath) {
//        var message = ""
//        var error = false
//        let isFavourite = dbHelper.isFavourite(pokemonId: pokemonId)
//        if isFavourite {
//            if !isFavourite(pokemonId: pokemonId) {
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
    
    func favouriteButtonTapped(showFavouritesButtonTitle: String?) -> String? {
        if showFavouritesButtonTitle == NSLocalizedString("ShowFavourites", comment: "") || showFavouritesButtonTitle == nil {
            let buttonString = NSLocalizedString("ShowAll", comment: "")
            let result = fetchFavouritesPokemonsUseCase.fetchFavouritesPokemons()
            switch result {
            case .success(let success):
                delegate?.favouriteLoaded(pokemons: success)
            case .failure(let failure):
                self.delegate?.didFailWithError(error: failure)
            }
            return buttonString
        } else {
            let buttonString = NSLocalizedString("ShowFavourites", comment: "")
            return buttonString
        }
    }
}

//MARK: - Favourite delegate
extension DefaultPokemonListPresenter: PokemonDetailDelegate {
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        delegate?.favouriteUpdated(pokemonID: pokemonID, isFavourite: isFavourite)
    }
}
