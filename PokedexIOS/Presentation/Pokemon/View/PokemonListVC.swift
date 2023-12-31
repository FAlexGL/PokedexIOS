//
//  PokemonListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import UIKit

class PokemonListVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var favouriteTableView: UITableView!
    
    private var coordinator: PokemonCoordinator
    private var pokemonsFetched: [String] = []
    private var favouritePokemonsFetched: [(pokemonID: Int, pokemonName: String)] = []
    private var pokemonListModel: PokemonListModel?
    private var url = Constants.PokemonAPI.URL_POKEMON_LIST
    private var apiHelper: APIHelper
    private let dbHelper: DBHelper = DefaultDBHelper.shared
    private var positionOfFavouritePokemonSelected: IndexPath?
    private var isShowingOnlyFavourites = false
    
    init(coordinator: PokemonCoordinator, apiHelper: APIHelper){
        self.apiHelper = apiHelper
        self.coordinator = coordinator
        super.init(nibName: Constants.NibNames.POKEMON_LIST, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegates()
        initTables()
        initNavigationControllerFavouriteButton()
        apiHelper.fetchPokemonList(url: url)
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
        apiHelper.delegate = self
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
    
    private func initTables(){
        tableView.dataSource = self
        favouriteTableView.dataSource = self
        tableView.delegate = self
        favouriteTableView.delegate = self
        tableView.rowHeight = 93.0
        favouriteTableView.rowHeight = 93.0
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER)
        favouriteTableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER)
    }
    
    @objc private func favouriteButtonTapped(_ sender: UIButton!){
        if !isShowingOnlyFavourites {
            favouriteTableView.isHidden = false
            favouritePokemonsFetched = dbHelper.fetchFavourites()
            isShowingOnlyFavourites = true
            let buttonString = NSLocalizedString("ShowAll", comment: "")
            sender.setTitle(buttonString, for: .normal)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.favouriteTableView.reloadData()
            }
        } else {
            favouriteTableView.isHidden = true
            let buttonString = NSLocalizedString("ShowFavourites", comment: "")
            sender.setTitle(buttonString, for: .normal)
            isShowingOnlyFavourites = false
        }
    }
    
    private func loadPokemonList() {
        if let pokemonList = self.pokemonListModel{
            for pokemon in pokemonList.pokemons {
                self.pokemonsFetched.append(pokemon)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func resetApp(){
        url = Constants.PokemonAPI.URL_POKEMON_LIST
        pokemonsFetched = []
        apiHelper.fetchPokemonList(url: url)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


extension PokemonListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == favouriteTableView {
            return favouritePokemonsFetched.count
        }
        return pokemonsFetched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == favouriteTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER, for: indexPath) as! PokemonCell
            cell.showData(pokemonID: self.favouritePokemonsFetched[indexPath.row].pokemonID, pokemonName: self.favouritePokemonsFetched[indexPath.row].pokemonName)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.POKEMON_CELL_IDENTIFIER, for: indexPath) as! PokemonCell
        cell.showData(pokemonID: indexPath.row + 1, pokemonName: self.pokemonsFetched[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stringFavourite = NSLocalizedString("Favourite", comment: "")
        let item = UIContextualAction(style: .normal, title: stringFavourite) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            //Control errrors
            var message = ""
            var error = false
            if tableView == self.favouriteTableView {
//                _ = self.dbHelper.deleteFavourite(pokemonId: self.favouritePokemonsFetched[indexPath.row].pokemonID)
                if (!self.dbHelper.deleteFavourite(pokemonId: self.favouritePokemonsFetched[indexPath.row].pokemonID)) {
                    message = "Error deletting favourite, try again."
                    error = true
                }
            } else {
                if self.dbHelper.isFavourite(pokemonId: indexPath.row+1) {
//                    _ = self.dbHelper.deleteFavourite(pokemonId: indexPath.row+1)
                    if (!self.dbHelper.deleteFavourite(pokemonId: indexPath.row+1)) {
                        message = "Error deletting favourite, try again."
                        error = true
                    }
                } else {
                    let favouritePokemon = FavouritePokemon(pokemonId: indexPath.row+1, pokemonName: self.pokemonsFetched[indexPath.row])
//                    _ = self.dbHelper.saveFavourite(favouritePokemon: favouritePokemon)
                    if (!self.dbHelper.saveFavourite(favouritePokemon: favouritePokemon)) {
                        message = "Error adding favourite Pokemon, try again"
                        error = true
                    }
                }
            }
            if error {
                let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
                self.present(alert , animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alert.dismiss(animated: true)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .none)
                if self.favouriteTableView.isHidden != true {
                    self.favouriteTableView.beginUpdates()
                    self.favouritePokemonsFetched.remove(at: indexPath.row)
                    self.favouriteTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.favouriteTableView.endUpdates()
                }
            }
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
        if tableView == self.tableView {
            let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == totalRows-1 && url != ""{
                apiHelper.fetchPokemonList(url: url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            coordinator.goToPokemonDetail(pokemonId: indexPath.row+1, delegate: self)
        } else if tableView == self.favouriteTableView {
            self.positionOfFavouritePokemonSelected = indexPath
            coordinator.goToPokemonDetail(pokemonId: favouritePokemonsFetched[indexPath.row].pokemonID, delegate: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension PokemonListVC: APIHelperDelegate{
    
    func didUpdatePokemonList(pokemonListModel: PokemonListModel) {
        self.pokemonListModel = pokemonListModel
        self.url = pokemonListModel.nextURL
        self.loadPokemonList()
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let errorVC = ErrorVC(nibName: Constants.NibNames.POKEMON_ERROR, bundle: nil)
            self.navigationController?.pushViewController(errorVC, animated: true)
        }
    }
}

extension PokemonListVC: PokemonDetailDelegate{
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        let indexPath = IndexPath(row: pokemonID-1, section: 0)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .none)
            if self.favouriteTableView.isHidden != true {
                if let indexPath = self.positionOfFavouritePokemonSelected {
                    self.favouriteTableView.beginUpdates()
                    self.favouritePokemonsFetched.remove(at: indexPath.row)
                    self.favouriteTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.favouriteTableView.endUpdates()
                }
            }
        }
    }
}
