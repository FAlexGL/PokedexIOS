//
//  PokemonListPresenter.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 9/1/24.
//

import Foundation
import UIKit
import Combine

protocol PokemonListViewDelegate {
    func didUpdatePokemonDetailsUpdated(pokemon: PokemonRepresentable)
    func didUpdatePokemonList(pokemonListDTO: PokemonListRepresentable)
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool)
    func favouriteLoaded(pokemons: [FavouritePokemon])
    func favouriteChanged(result: Bool, messageError: String, indexPath: IndexPath)
    func didFailWithError(error: Error)
}

protocol PokemonCellViewDelegate {
    func didFetchImage(image: UIImage)
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
    func addSubscribers(publisher: AnyPublisher<String, Never>)
}

class DefaultPokemonListPresenter {
    var delegate: PokemonListViewDelegate?
    
    private var subscriptions: Set<AnyCancellable> = []
    private var pokemons: [PokemonRepresentable] = []
    private let coordinator: PokemonCoordinator
    private let fetchPokemonsUseCase: FetchPokemonsUseCase
    private let fetchFavouritePokemonsUseCase: FetchFavouritePokemonsUseCase
    private let updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase
    
    init(coordinator: PokemonCoordinator, fetchPokemonsUseCase: FetchPokemonsUseCase, fetchFavouritePokemonsUseCase: FetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase) {
        self.coordinator = coordinator
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.fetchFavouritePokemonsUseCase = fetchFavouritePokemonsUseCase
        self.updateFavouritePokemonsUseCase = updateFavouritePokemonsUseCase
    }
}


//MARK: - Presenter delegate
extension DefaultPokemonListPresenter: PokemonListPresenter {
    
    func addSubscribers(publisher: AnyPublisher<String, Never>) {
        publisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .print("[SEARCH]")
            .filter { $0.count >= 3 }
            .map { $0.lowercased() }
            .flatMap {
                self.fetchPokemonsUseCase.fetchPokemonDetail(pokemonIdOrName: $0)
                    .retry(3)
                    .map { result -> PokemonRepresentable? in
                        result
                    }
                    .replaceError(with: nil)
            }
            .sink { pokemon in
                guard let pokemon = pokemon else {
                    print("the pokemon doesn't exist")
                    return
                }
                DispatchQueue.main.async {
                    self.coordinator.goToPokemonDetail(pokemonId: pokemon.id, delegate: self)
                }
            }
            .store(in: &subscriptions)
    }
    
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
        fetchPokemonsUseCase.fetchPokemonList()
            .handleEvents(receiveOutput: { pokemonListRepresentable in
                self.delegate?.didUpdatePokemonList(pokemonListDTO: pokemonListRepresentable)
            })
            .map { $0.results }
            .flatMap { $0.publisher }
            .flatMap { self.fetchPokemonsUseCase.fetchPokemonDetail(pokemonIdOrName: $0.name) }
            .collect()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Pokemons Fetched")
                case .failure(_):
                    print("Error fetching Pokemons")
                }
            } receiveValue: { [weak self] value in
                guard let self = self else {return}
                value.forEach { self.delegate?.didUpdatePokemonDetailsUpdated(pokemon: $0) }
            }
            .store(in: &subscriptions)
    }
    
    func willDisplay(showFavouritesButtonTitle: String?, totalRows: Int, indexPath: IndexPath, url: String) {
        if showFavouritesButtonTitle != NSLocalizedString("ShowAll", comment: "") {
            if indexPath.row == totalRows - 1 && url != "" {
                fetchPokemonsUseCase.fetchPokemonList(url: url)
                    .handleEvents(receiveOutput: { [weak self] pokemonListRepresentable in
                        guard let self = self else {return}
                        self.delegate?.didUpdatePokemonList(pokemonListDTO: pokemonListRepresentable)
                    })
                    .map { $0.results }
                    .flatMap { $0.publisher }
                    .flatMap { self.fetchPokemonsUseCase.fetchPokemonDetail(pokemonIdOrName: $0.name) }
                    .collect()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("Pokemons Fetched")
                        case .failure(_):
                            print("Error fetching Pokemons")
                        }
                    } receiveValue: { value in
                        value.forEach { self.delegate?.didUpdatePokemonDetailsUpdated(pokemon: $0) }
                    }
                    .store(in: &subscriptions)
            }
        }
    }
    
    func numberOfRowsInSection (showFavouritesButtonTitle: String?, favouritePokemonsFetched: Int, pokemonsFetched: Int) -> Int {
        if showFavouritesButtonTitle == NSLocalizedString("ShowAll", comment: "") {
            return favouritePokemonsFetched
        }
        return pokemonsFetched
    }
    
    func cellForRowAt2(indexPath: IndexPath, showFavouritesButtonTitle: String?, favouritePokemonsFetched: [FavouritePokemon], pokemonsFetched: [PokemonRepresentable]) {
        
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath, showFavouritesButtonTitle: String?, favouritePokemonsFetched: [FavouritePokemon], pokemonsFetched: [String]) -> UITableViewCell {
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
        let favouritePokemon = FavouritePokemon(pokemonId: pokemonId, pokemonName: pokemonName)
        let result = updateFavouritePokemonsUseCase.updateFavourite(favouritePokemon: favouritePokemon)
        
        delegate?.favouriteChanged(result: result, messageError: "Error updating favourite", indexPath: indexPath)
    }
    
    func favouriteButtonTapped(showFavouritesButtonTitle: String?) -> String? {
        if showFavouritesButtonTitle == NSLocalizedString("ShowFavourites", comment: "") || showFavouritesButtonTitle == nil {
            let buttonString = NSLocalizedString("ShowAll", comment: "")
            let result = fetchFavouritePokemonsUseCase.fetchFavouritePokemons()
            switch result {
            case .success(let pokemons):
                delegate?.favouriteLoaded(pokemons: pokemons)
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
