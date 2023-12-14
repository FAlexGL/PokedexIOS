//
//  PokemonListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 11/12/23.
//

import UIKit

class PokemonListVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var switchTableView: UISwitch!
    @IBOutlet weak var favouriteTableView: UITableView!
    
    private var pokemonsFetched: [String] = []
    private var favouritePokemonsFetched: [(pokemonID: Int, pokemonName: String)] = []
    private var pokemonListModel: PokemonListModel?
    private var url = K.PokemonAPI.URL_POKEMON_LIST
    private var apiHelper = APIHelper.share
    private let dbHelper = DBHelper.shared
    private let pokemonDetailVC = PokemonDetailVC(nibName: K.NibNames.POKEMON_DETAIL, bundle: nil)
    private var positionOfFavouritePokemonSelected: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiHelper.delegate = self
        pokemonDetailVC.delegate = self
        tableView.dataSource = self
        favouriteTableView.dataSource = self
        tableView.delegate = self
        favouriteTableView.delegate = self
        tableView.rowHeight = 70.0
        favouriteTableView.rowHeight = 70.0
        tableView.register(UINib(nibName: "PokemonCellVC", bundle: nil), forCellReuseIdentifier: K.Identifiers.POKEMON_CELL_IDENTIFIER)
        favouriteTableView.register(UINib(nibName: "PokemonCellVC", bundle: nil), forCellReuseIdentifier: K.Identifiers.POKEMON_CELL_IDENTIFIER)
        apiHelper.fetchPokemonList(url: url)
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
    
    @IBAction func favouriteSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            favouritePokemonsFetched = dbHelper.fetchFavourites()
            DispatchQueue.main.async {
                self.favouriteTableView.reloadData()
            }
        }
        favouriteTableView.isHidden = !sender.isOn
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
        if let cell = self.tableView.cellForRow(at: indexPath) as? PokemonCellVC{
            cell.favouriteImage.isHidden = !isFavourite
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        if self.favouriteTableView.isHidden != true {
            if let indexPath = self.positionOfFavouritePokemonSelected {
                favouriteTableView.beginUpdates()
                favouritePokemonsFetched.remove(at: indexPath.row)
                favouriteTableView.deleteRows(at: [indexPath], with: .automatic)
                favouriteTableView.endUpdates()
            }
        }
    }
}
