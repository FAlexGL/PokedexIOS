//
//  PokemonListPresenter.swift
//  PokedexIOS
//
//  Created by Daniel Cerero Lozano on 9/1/24.
//

import Foundation
import Combine

protocol PokemonListViewDelegate {
    func didUpdatePokemonDetailsUpdated(pokemon: [PokemonRepresentable])
    func didUpdatePokemonList(pokemonListDTO: PokemonListRepresentable)
    func didUpdatePokemonsFoundByUser(pokemonsFoundByUser: [PokemonRepresentable])
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool)
    func favouriteLoaded(pokemons: [FavouritePokemon])
    func favouriteChanged(result: Bool, messageError: String, indexPath: IndexPath)
    func didFailWithError(error: Error)
}

protocol PokemonListPresenter {
    var delegate: PokemonListViewDelegate? { get set }
    var statePublisher: AnyPublisher<PokemonListState, Never> { get }
    
    func didSelectRowAt(pokemon: PokemonRepresentable)
    func viewDidLoad()
    func willDisplay(totalRows: Int, indexPath: IndexPath)
    func numberOfRowsInSection (showFavouritesButtonTitle: String?, pokemons: [PokemonRepresentable]) -> Int
    func cellForRowAt(indexPath: IndexPath, showFavouritesButtonTitle: String?, favouritePokemonsFetched: [FavouritePokemon], pokemonsFetched: [PokemonRepresentable]) -> (pokemonId: Int, pokemonName: String)
    func trailingSwipeActionsConfigurationForRowAt(pokemon: PokemonRepresentable, indexPath: IndexPath)
    func favouriteButtonTapped() -> String?
    func addSubscribers(publisher: AnyPublisher<String, Never>)
}

enum PokemonListState {
    case idle
    case reloadTable([PokemonRepresentable])
    case favoriteChanged(IndexPath)
    case showError(String)
}

enum PokemonDataSource {
    case api
    case db
}


class DefaultPokemonListPresenter {
    var delegate: PokemonListViewDelegate?
    
    private var loadedPokemons: [PokemonRepresentable] = []
    private var storedPokemons: [PokemonRepresentable] = []
    private var subscriptions = Set<AnyCancellable>()
    private var showingFavourites = false
    private var isPaginating = true
    private let coordinator: PokemonCoordinator
    private let fetchPokemonsUseCase: FetchPokemonsUseCase
    private let fetchFavouritePokemonsUseCase: FetchFavouritePokemonsUseCase
    private let updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase
    private let dbHelper: DBHelper
        
    private var stateSubject = CurrentValueSubject<PokemonListState, Never>(.idle)
    public var statePublisher: AnyPublisher<PokemonListState, Never> {
        stateSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private var pageUrl: String?
    private var searchText: String?
    private var pokemonDataSource: PokemonDataSource = .api
    private var filteredPokemons: [PokemonRepresentable] {
        var filteredPokemons: [PokemonRepresentable]
        switch pokemonDataSource {
        case .api: filteredPokemons = loadedPokemons
        case .db: filteredPokemons = storedPokemons
        }
        
        if let searchText = searchText {
            filteredPokemons = filteredPokemons.filter { $0.name.contains(searchText) }
        }
        
        return filteredPokemons
    }
    
    init(coordinator: PokemonCoordinator, fetchPokemonsUseCase: FetchPokemonsUseCase, fetchFavouritePokemonsUseCase: FetchFavouritePokemonsUseCase, updateFavouritePokemonsUseCase: UpdateFavouritePokemonsUseCase, dbHelper: DBHelper) {
        self.coordinator = coordinator
        self.fetchPokemonsUseCase = fetchPokemonsUseCase
        self.fetchFavouritePokemonsUseCase = fetchFavouritePokemonsUseCase
        self.updateFavouritePokemonsUseCase = updateFavouritePokemonsUseCase
        self.dbHelper = dbHelper
    }
    
    func viewDidLoad() {
        fetchMoreData(url: nil)
    }
}

//MARK: - Presenter delegate
extension DefaultPokemonListPresenter: PokemonListPresenter {
    
    private func reloadTable() {
        stateSubject.send(.reloadTable(filteredPokemons))
    }
    
    func addSubscribers(publisher: AnyPublisher<String, Never>) {
        publisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .filter { $0.count == 0 }
            .sink { [weak self] result in
                self?.searchText = nil
                self?.reloadTable()
//                self.delegate?.didUpdatePokemonsFoundByUser(pokemonsFoundByUser: [])
            }
            .store(in: &subscriptions)
        
        publisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//            .print("[SEARCH]")
            .filter { $0.count >= 3 }
            .map { $0.lowercased() }
            .flatMap { [unowned self] searchText -> AnyPublisher<[PokemonRepresentable], Never> in
                self.searchText = searchText
                pokemonDataSource = showingFavourites ? .db : .api
                if filteredPokemons.isEmpty {
                    return self.fetchPokemonsUseCase.fetchPokemonDetail(pokemonIdOrName: searchText)
                        .retry(3)
                        .map { result -> [PokemonRepresentable] in
                            return [result]
                        }
                        .replaceError(with: [])
                        .eraseToAnyPublisher()
                } else {
                    return Just(filteredPokemons).eraseToAnyPublisher()
                }
            }
            .sink { [unowned self] pokemons in
                self.isPaginating = false
                if self.filteredPokemons.isEmpty {
                    self.stateSubject.send(.reloadTable(pokemons))
                } else {
                    self.reloadTable()
                }
            }
            .store(in: &subscriptions)
    }
    
    func didSelectRowAt(pokemon: PokemonRepresentable) {
        coordinator.goToPokemonDetail(pokemonName: pokemon.name, delegate: self, pokemonDetail: pokemon)
    }
    
    
    func willDisplay(totalRows: Int, indexPath: IndexPath) {
        guard case .reloadTable = stateSubject.value,
              let pageUrl = pageUrl, !pageUrl.isEmpty,
              indexPath.row == totalRows - 1,
              isPaginating else {
            return
        }
        fetchMoreData(url: pageUrl)
    }
    
    func numberOfRowsInSection (showFavouritesButtonTitle: String?, pokemons: [PokemonRepresentable]) -> Int {
        if showFavouritesButtonTitle == NSLocalizedString("ShowAll", comment: "") {
            return dbHelper.fetchFavourites().count
        }
        return pokemons.count
    }
    
    func cellForRowAt(indexPath: IndexPath, showFavouritesButtonTitle: String?, favouritePokemonsFetched: [FavouritePokemon], pokemonsFetched: [PokemonRepresentable]) -> (pokemonId: Int, pokemonName: String) {
        if showFavouritesButtonTitle == NSLocalizedString("ShowAll", comment: "") {
            return(favouritePokemonsFetched[indexPath.row].pokemonId, favouritePokemonsFetched[indexPath.row].pokemonName)
        }
        return(pokemonsFetched[indexPath.row].id, pokemonsFetched[indexPath.row].name)
    }
    
    func trailingSwipeActionsConfigurationForRowAt(pokemon: PokemonRepresentable, indexPath: IndexPath) {
        let favouritePokemon = FavouritePokemon(pokemonId: pokemon.id, pokemonName: pokemon.name)
        let _ = updateFavouritePokemonsUseCase.updateFavourite(favouritePokemon: favouritePokemon)
        stateSubject.send(.favoriteChanged(indexPath))
//        delegate?.favouriteChanged(result: result, messageError: "Error updating favourite", indexPath: indexPath)
    }
    
    func favouriteButtonTapped() -> String? {
        showingFavourites = !showingFavourites
        if showingFavourites {
            isPaginating = false
            let result = fetchFavouritePokemonsUseCase.fetchFavouritePokemons()
            switch result {
            case .success(let pokemons):
                var publishers: [AnyPublisher<PokemonRepresentable, Error>] = []
                pokemons.forEach { favouritePokemon in
                    publishers.append(fetchPokemonsUseCase.fetchPokemonDetail(pokemonIdOrName: favouritePokemon.pokemonName))
                }
                
                let _ = Publishers.Zip(publishers[0], publishers[1])
                    .sink { result in
                        //
                    } receiveValue: { pok1, pok2 in
                        self.storedPokemons = []
                        self.storedPokemons.append(pok1)
                        self.storedPokemons.append(pok2)
                        self.stateSubject.send(.reloadTable(self.storedPokemons))
                    }
                    .store(in: &subscriptions)
            case .failure(let failure):
                self.delegate?.didFailWithError(error: failure)
            }
            return NSLocalizedString("ShowAll", comment: "")
        } else {
            isPaginating = true
            stateSubject.send(.reloadTable(loadedPokemons))
            return NSLocalizedString("ShowFavourites", comment: "")
    }
//        if showFavouritesButtonTitle == NSLocalizedString("ShowFavourites", comment: "") || showFavouritesButtonTitle == nil {
//            let buttonString = NSLocalizedString("ShowAll", comment: "")
//            let result = fetchFavouritePokemonsUseCase.fetchFavouritePokemons()
//            switch result {
//            case .success(let pokemons):
//                delegate?.favouriteLoaded(pokemons: pokemons)
//            case .failure(let failure):
//                self.delegate?.didFailWithError(error: failure)
//            }
//            return buttonString
//        } else {
//            let buttonString = NSLocalizedString("ShowFavourites", comment: "")
//            return buttonString
//        }
    }
    
    private func fetchMoreData(url: String?) {
        fetchPokemonsUseCase.fetchPokemonList(url: url)
            .handleEvents(receiveOutput: { [weak self] pokemonListRepresentable in
                self?.pageUrl = pokemonListRepresentable.next
//                self.delegate?.didUpdatePokemonList(pokemonListDTO: pokemonListRepresentable)
            })
            .map { $0.results }
            .flatMap { $0.publisher }
            .flatMap { self.fetchPokemonsUseCase.fetchPokemonDetail(pokemonIdOrName: $0.name) }
            .collect()
            .replaceError(with: [])
            .sink { [weak self] pokemons in
                guard let self = self else {return}
                pokemons.forEach { pokemon in
                    self.loadedPokemons.append(pokemon)
                }
                self.stateSubject.send(.reloadTable(self.loadedPokemons))
//                self.delegate?.didUpdatePokemonDetailsUpdated(pokemon: allFetchedPokemonsWithFavouriteValue)
            }
            .store(in: &subscriptions)
    }
}

//MARK: - Favourite delegate
extension DefaultPokemonListPresenter: PokemonDetailDelegate {
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        delegate?.favouriteUpdated(pokemonID: pokemonID, isFavourite: isFavourite)
    }
}
