//
//  PokemonListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import UIKit

class PokemonListVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var pokemonsFetched: [String] = []
    private var favouritePokemonsFetched: [FavouritePokemon] = []
    private var pokemonListModel: PokemonListModel?
    private var url = Constants.PokemonAPI.URL_POKEMON_LIST
    private var positionOfFavouritePokemonSelected: IndexPath?
    private var presenter: PokemonListPresenter
    
    init(presenter: PokemonListPresenter){
        self.presenter = presenter
        super.init(nibName: Constants.NibNames.POKEMON_LIST, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegates()
        initTable()
        initNavigationControllerFavouriteButton()
        presenter.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavController()
    }
    
    private func setNavController(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func initDelegates(){
        presenter.delegate = self
    }
    
    private func initNavigationControllerFavouriteButton(){
        let buttonFavourites = UIButton(type: .system)
        buttonFavourites.tintColor = UIColor.white
        let buttonString = NSLocalizedString("ShowFavourites", comment: "")
        buttonFavourites.setTitle(buttonString, for: .normal)
        buttonFavourites.addTarget(self, action: #selector(favouriteButtonTapped(_:)), for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: buttonFavourites)
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    private func initTable(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 93.0
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER)
    }
    
    @objc private func favouriteButtonTapped(_ sender: UIButton!){
        let showFavouritesButtonTitle = navigationItem.rightBarButtonItem?.title
        navigationItem.rightBarButtonItem?.title = presenter.favouriteButtonTapped(showFavouritesButtonTitle: showFavouritesButtonTitle)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func loadPokemonList() {
        if let pokemonList = self.pokemonListModel {
            for pokemon in pokemonList.pokemons {
                self.pokemonsFetched.append(pokemon)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


extension PokemonListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let showFavouritesButtonTitle = self.navigationItem.rightBarButtonItem?.title
        return presenter.numberOfRowsInSection(showFavouritesButtonTitle: showFavouritesButtonTitle, favouritePokemonsFetched: favouritePokemonsFetched.count, pokemonsFetched: pokemonsFetched.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showFavouritesButtonTitle = self.navigationItem.rightBarButtonItem?.title
        return presenter.cellForRowAt(tableView: tableView, indexPath: indexPath, showFavouritesButtonTitle: showFavouritesButtonTitle, favouritePokemonsFetched: favouritePokemonsFetched, pokemonsFetched: pokemonsFetched)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stringFavourite = NSLocalizedString("Favourite", comment: "")
        let item = UIContextualAction(style: .normal, title: stringFavourite) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let pokemonId = self.navigationItem.rightBarButtonItem?.title ==  NSLocalizedString("ShowAll", comment: "") ? favouritePokemonsFetched[indexPath.row].pokemonId : indexPath.row + 1
            
            self.presenter.trailingSwipeActionsConfigurationForRowAt(pokemonId: pokemonId, pokemonName: self.pokemonsFetched[indexPath.row], indexPath: indexPath)
            completionHandler(true)
        }
        item.image = UIImage(named: Constants.Images.POKEBALL_FAVOURITE)
        item.backgroundColor = UIColor(named: Constants.Colours.BLUE_POKEMON_TITLE)
        let swipeActions = UISwipeActionsConfiguration(actions: [item])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
    
}

extension PokemonListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let showFavouritesButtonTitle = self.navigationItem.rightBarButtonItem?.title
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        presenter.willDisplay(showFavouritesButtonTitle: showFavouritesButtonTitle, totalRows: totalRows, indexPath: indexPath, url: url)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.positionOfFavouritePokemonSelected = indexPath
        let showFavouritesButtonTitle = self.navigationItem.rightBarButtonItem?.title
        presenter.didSelectRowAt(showFavouritesButtonTitle: showFavouritesButtonTitle, indexPath: indexPath, favouritePokemonsFetched: favouritePokemonsFetched)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension PokemonListVC: PokemonListViewDelegate {
    
    func didUpdatePokemonList(pokemonListModel: PokemonListModel) {
        self.pokemonListModel = pokemonListModel
        self.url = pokemonListModel.nextURL
        self.loadPokemonList()
    }
    
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        let indexPath = IndexPath(row: pokemonID - 1, section: 0)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .none)
            if self.navigationItem.rightBarButtonItem?.title ==  NSLocalizedString("ShowAll", comment: "") {
                if let indexPath = self.positionOfFavouritePokemonSelected {
                    self.tableView.beginUpdates()
                    self.favouritePokemonsFetched.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    func favouriteLoaded(pokemons: [FavouritePokemon]) {
        favouritePokemonsFetched = pokemons
        let buttonString = NSLocalizedString("ShowAll", comment: "")
        self.navigationItem.rightBarButtonItem?.title = buttonString
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func favouriteChanged(error: Bool, message: String, indexPath: IndexPath) {
        if error {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
            self.present(alert , animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if  self.navigationItem.rightBarButtonItem?.title ==  NSLocalizedString("ShowAll", comment: "") {
                self.tableView.beginUpdates()
                self.favouritePokemonsFetched.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            } else {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let errorVC = ErrorVC(nibName: Constants.NibNames.POKEMON_ERROR, bundle: nil)
            self.navigationController?.pushViewController(errorVC, animated: true)
        }
    }
}
