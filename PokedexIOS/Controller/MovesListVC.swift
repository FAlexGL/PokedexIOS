//
//  MovesListVC.swift
//  PokedexIOS
//
//  Created by Fernando Alejandro Garcia Lopez on 13/12/23.
//

import UIKit

class MovesListVC: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    private var pokemonModel: PokemonModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    func showData(pokemonModel: PokemonModel){
        DispatchQueue.main.async {
            self.pokemonModel = pokemonModel
            self.tableView.reloadData()
        }
    }
    
}

extension MovesListVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pokemonModel = self.pokemonModel{
            return pokemonModel.moves.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = pokemonModel?.moves[indexPath.row].moveName.replacingOccurrences(of: "-", with: " ")
        content.textProperties.font = UIFont.systemFont(ofSize: 20)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension MovesListVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moveDetailVC = MoveDetailVC(nibName: K.NibNames.POKEMON_MOVE_DETAIL, bundle: nil)
        if let pokemonModel = self.pokemonModel {
            DispatchQueue.main.async {
                moveDetailVC.showData(move: pokemonModel.moves[indexPath.row])
                self.navigationController?.pushViewController(moveDetailVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
