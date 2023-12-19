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
    
    private var pokemonsFetched: [String] = []
    private var favouritePokemonsFetched: [(pokemonID: Int, pokemonName: String)] = []
    private var pokemonListModel: PokemonListModel?
    private var url = K.PokemonAPI.URL_POKEMON_LIST
    private var apiHelper = APIHelper.share
    private let dbHelper = DBHelper.shared
    private let pokemonDetailVC = PokemonDetailVC(nibName: K.NibNames.POKEMON_DETAIL, bundle: nil)
    private var positionOfFavouritePokemonSelected: IndexPath?
    private var isShowingOnlyFavourites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegates()
        initTables()
        initNavigationControllerFavouriteButton()
        
        apiHelper.fetchPokemonList(url: url)
    }
    
    private func initDelegates(){
        apiHelper.delegate = self
        pokemonDetailVC.delegate = self
    }
    
    private func initNavigationControllerFavouriteButton(){
        let buttonFavourites = UIButton(type: .system)
        buttonFavourites.tintColor = UIColor.white
        buttonFavourites.setTitle("Show Favourites", for: .normal)
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
        tableView.register(UINib(nibName: "PokemonCellVC", bundle: nil), forCellReuseIdentifier: K.Identifiers.POKEMON_CELL_IDENTIFIER)
        favouriteTableView.register(UINib(nibName: "PokemonCellVC", bundle: nil), forCellReuseIdentifier: K.Identifiers.POKEMON_CELL_IDENTIFIER)
    }
        
    @objc private func favouriteButtonTapped(_ sender: UIButton!){
        if !isShowingOnlyFavourites {
            favouriteTableView.isHidden = false
            favouritePokemonsFetched = dbHelper.fetchFavourites()
            isShowingOnlyFavourites = true
            sender.setTitle("Show all", for: .normal)
            DispatchQueue.main.async {
                self.favouriteTableView.reloadData()
            }
        } else {
            favouriteTableView.isHidden = true
            sender.setTitle("Show Favourites", for: .normal)
            isShowingOnlyFavourites = false
        }
    }
    
    private func loadPokemonList() {
        if let pokemonList = self.pokemonListModel{
            for pokemon in pokemonList.pokemons {
                self.pokemonsFetched.append(pokemon)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func resetApp(){
        url = K.PokemonAPI.URL_POKEMON_LIST
        pokemonsFetched = []
        apiHelper.fetchPokemonList(url: url)
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.POKEMON_CELL_IDENTIFIER, for: indexPath) as! PokemonCellVC
            cell.showData(pokemonID: self.favouritePokemonsFetched[indexPath.row].pokemonID, pokemonName: self.favouritePokemonsFetched[indexPath.row].pokemonName)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.POKEMON_CELL_IDENTIFIER, for: indexPath) as! PokemonCellVC
        cell.showData(pokemonID: indexPath.row+1, pokemonName: self.pokemonsFetched[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .normal, title: "Favourite") { (action, view, completionHandler) in
            if tableView == self.favouriteTableView {
                self.dbHelper.deleteFavourite(pokemonId: self.favouritePokemonsFetched[indexPath.row].pokemonID)
            } else {
                if self.dbHelper.isFavourite(pokemonId: indexPath.row+1){
                    self.dbHelper.deleteFavourite(pokemonId: indexPath.row+1)
                } else {
                    let favouritePokemon = FavouritePokemon(pokemonId: indexPath.row+1, pokemonName: self.pokemonsFetched[indexPath.row])
                    self.dbHelper.saveFavourite(favouritePokemon: favouritePokemon)
                }
            }
            DispatchQueue.main.async {
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
        item.image = UIImage(named: K.Images.POKEBALL_FAVOURITE)
        item.backgroundColor = UIColor(named: K.Colours.BLUE_POKEMON_TITLE)
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
            apiHelper.fetchPokemonDetail(pokemonId: indexPath.row+1)
            navigationController?.pushViewController(pokemonDetailVC, animated: true)
        } else if tableView == self.favouriteTableView {
            self.positionOfFavouritePokemonSelected = indexPath
            apiHelper.fetchPokemonDetail(pokemonId: favouritePokemonsFetched[indexPath.row].pokemonID)
            navigationController?.pushViewController(pokemonDetailVC, animated: true)
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
        let errorVC = ErrorVC(nibName: K.NibNames.POKEMON_ERROR, bundle: nil)
        navigationController?.pushViewController(errorVC, animated: true)
    }
    
    func didUpdatePokemonDetail(pokemonModel: PokemonModel) {
        pokemonDetailVC.showData(pokemonModel: pokemonModel)
    }
}

extension PokemonListVC: PokemonDetailDelegate{
    func favouriteUpdated(pokemonID: Int, isFavourite: Bool) {
        let indexPath = IndexPath(row: pokemonID-1, section: 0)
        DispatchQueue.main.async {
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
